import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wrapp/Utilities/Storage.dart';

class DQList extends StatefulWidget {
  const DQList({Key? key}) : super(key: key);

  @override
  State<DQList> createState() => _DQListState();
}

class _DQListState extends State<DQList> {
  List<bool> isFavorited = [];
  List<NameAndText> dqList = [
    // 'This gun smells like my grannys fanny - Harry',
    // "Yeah surely you don't get penalised for pulling a Kiddo - Daniel",
    // 'I concur my balls in your ass - Eoin',
    // 'Anne Franks Hot Sauce - Daniel',
    // 'We did the head thing - Jacques',
  ];
  List<String> retrievedDqList = ['Not Loaded'];
  late DatabaseReference dqDatabase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshDqsFavs();
    dqDatabase = FirebaseDatabase.instance.ref("dqs");
  }

  void refreshDqsFavs() async {
    isFavorited.add(false);
    for (int i = 0; i < 10; i++) {
      isFavorited.add(false);
    }
  }

  var names = [
    'Select Name',
    'Jacques',
    'James',
    'Shane',
    'Harry',
    'Carl',
    'Calem',
    'Sean',
    'Daniel',
    'Rory',
    'Eoin',
  ];

  String dropdownvalue = 'Select Name';

  void setDqs(NameAndText nameAndText) async {
    final newPostKey = dqDatabase.push().key;
    final Map<String, Map> updates = {};
    final postData = {'text': nameAndText.text, 'name': nameAndText.name};
    updates['/$newPostKey'] = postData;
    dqDatabase.update(updates);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textControl = TextEditingController();
    // List<NameAndText> nameAndTextList = [];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('DQs'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: ((context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('Add DQ'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'DQ',
                                    ),
                                    controller: textControl,
                                  ),
                                  DropdownButton(
                                    value: dropdownvalue,
                                    // icon: const Icon(Icons.keyboard_arrow_down),
                                    items: names.map((String names) {
                                      return DropdownMenuItem(
                                        value: names,
                                        child: Text(names),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: const Text("Add"),
                                onPressed: () {
                                  setState(() {
                                    setDqs(NameAndText(
                                        text: textControl.text,
                                        name: dropdownvalue));
                                    // getDqs();
                                    // print(nameAndTextList.length);
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        );
                      }),
                    );
                  });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: dqDatabase.orderByKey().limitToFirst(10).onValue,
        builder: (context, snapshot) {
          List<NameAndText> nameAndTextList = [];
          if (snapshot.hasData) {
            if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
              final data = Map<dynamic, dynamic>.from(
                  (snapshot.data as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
              data.forEach((key, value) {
                var detail = Map<dynamic, dynamic>.from(value);
                nameAndTextList.add(
                    NameAndText(text: detail['text'], name: detail['name']));
              });
            }
          }
          return (snapshot.connectionState != ConnectionState.active)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nameAndTextList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                '${nameAndTextList[index].text} - ${nameAndTextList[index].name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                    isFavorited[index]
                                        ? Icons.favorite
                                        : Icons.favorite_border_rounded,
                                    color: Colors.red),
                                onPressed: () => {dQFav(index)}),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                );
        },
      ),
    );
  }

  void dQFav(int index) {
    setState(
      () {
        bool temp = isFavorited[index];
        isFavorited.removeAt(index);
        isFavorited.insert(index, !temp);
      },
    );
  }

  // Storage storageController = Storage();
  // var key = 'dqList';
  // void commitToLocal(String newEntry) {
  //   storageController.storeData(key, newEntry);
  // }

  // Future<List<String>> getFromLocal() async {
  //   return storageController.retrieveData(key);
  // }
}

class NameAndText {
  String name;
  String text;

  NameAndText({required this.text, required this.name});
}
