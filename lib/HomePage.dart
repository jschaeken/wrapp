import 'package:flutter/material.dart';
import 'package:wrapp/Screens/Betting.dart';
import 'package:wrapp/Screens/DQList.dart';
import 'package:wrapp/Screens/ProfileView.dart';

import 'Screens/Voting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> widgetList = [
    MaterialButton(
      height: 250,
      color: Colors.blue,
      onPressed: () => {},
      child: Text('Button'),
    ),
    MaterialButton(
      onPressed: () => {},
      child: Text('Button'),
    ),
    MaterialButton(
      onPressed: () => {},
      child: Text('Button'),
    ),
    MaterialButton(
      onPressed: () => {},
      child: Text('Button'),
    ),
    MaterialButton(
      onPressed: () => {},
      child: Text('Button'),
    ),
  ];

  List<String> baseNames = [
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

  List<Color> colorSwitches = [
    Colors.blue,
    Colors.red,
    Colors.black,
  ];

  List<String> topics = [
    'Betting',
    'Voting',
    'DQs',
  ];

  List<Widget> pages = [];
  List screens = [
    Betting(),
    Voting(),
    DQList(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.separated(
                itemCount: topics.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                    height: 50,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screens[index]),
                      )
                    },
                    color: colorSwitches[index % colorSwitches.length],
                    child: Center(
                        child: Text(
                      topics[index],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Profiles',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (SingleChildScrollView(
                  child: ListView.separated(
                    itemCount: baseNames.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return MaterialButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileView(baseNames[index])),
                          ),
                        },
                        height: 50,
                        color: Theme.of(context).colorScheme.background,
                        child: Center(child: Text(baseNames[index])),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

DQs
Bets
Voting
Profiles
Comment section


*/
