import 'package:flutter/material.dart';

import '../Utilities/network.dart';

class DomCodes extends StatelessWidget {
  const DomCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //write a scaffold with an appbar and a body
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domino\'s Codes'),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: FutureBuilder(
              future: Network().parser(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  var setCodes = snapshot.data as Set<String>;
                  var codesReversed = setCodes.toList();
                  var codeList = codesReversed.reversed.toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var code = codeList[index];
                      return ListTile(
                        onTap: () => {},
                        title: Text(code),
                        subtitle: const Text('Discount Amount: X%'),
                        leading: const Icon(Icons.attach_money_outlined),
                      );
                    },
                    itemCount: codeList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
          ),
        ]),
      ),
    );
  }
}
