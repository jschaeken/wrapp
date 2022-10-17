import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshDqs();
  }

  void refreshDqs() {
    for (NameAndText s in dqList) {
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

  @override
  Widget build(BuildContext context) {
    TextEditingController textControl = TextEditingController();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('DQs'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Add DQ'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Dq',
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
                                dqList.insert(
                                    0,
                                    NameAndText(
                                        textControl.text, dropdownvalue));
                                refreshDqs();
                                Navigator.pop(context);
                              });
                            })
                      ],
                    );
                  });
            },
            icon: Icon(Icons.add_circle_outline_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: dqList.length,
          itemBuilder: (_, index) {
            // String value = listValues[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      '${dqList[index].text.toString()} - ${dqList[index].name.toString()}',
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
      ),
    ));
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
}

class NameAndText {
  String name;
  String text;

  NameAndText(this.text, this.name);
}
