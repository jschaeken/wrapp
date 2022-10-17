import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Voting extends StatefulWidget {
  const Voting({Key? key}) : super(key: key);

  @override
  State<Voting> createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Center(
            child: Text('Voting Screen'),
          ),
        ],
      ),
    ));
  }
}
