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
  List<String> dqList = [
    'This gun smells like my grannys fanny - Harry',
    "Yeah surely you don't get penalised for pulling a Kiddo - Daniel",
    'I concur my balls in your ass - Eoin',
    'Anne Franks Hot Sauce - Daniel',
    'We did the head thing - Jacques',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
    'idk yet',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavorited = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
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
                      dqList[index],
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
