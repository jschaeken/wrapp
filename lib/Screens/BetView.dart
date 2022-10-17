import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BetView extends StatefulWidget {
  const BetView({Key? key}) : super(key: key);

  @override
  State<BetView> createState() => _BetViewState();
}

class _BetViewState extends State<BetView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: Column(children: [Center(child: Text('Betting Data'))]),
      ),
    );
  }
}
