import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wrapp/Screens/Betting.dart';
import 'package:wrapp/Screens/DQList.dart';
import 'package:wrapp/Screens/ProfileView.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Screens/Voting.dart';
import 'firebase_options.dart';

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
  int counter = 0;
  List screens = [
    Betting(),
    Voting(),
    DQList(),
  ];
  late DatabaseReference usersDatabase;
  late DatabaseReference dqDatabase;
  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  void initDatabase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    usersDatabase = FirebaseDatabase.instance.ref("users");
  }

  void setNames(int i) async {
    usersDatabase.update({'Name ${i.toString()}': baseNames[i]});
  }

  void setDqs(NameAndText nameAndText) async {
    dqDatabase.update({'string': nameAndText.text, 'name': nameAndText.name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.separated(
              itemCount: screens.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
            Spacer(
              flex: 1,
            ),
            MaterialButton(
              onPressed: (() {
                setState(() {
                  for (int i = 0; i < baseNames.length; i++) {
                    setNames(i);
                  }
                });
              }),
              child: Text('Add names'),
            ),
            MaterialButton(
              onPressed: (() {
                setState(() {
                  for (int i = 0; i < baseNames.length; i++) {
                    setDqs(NameAndText(
                        text: 'Some loose dq here', name: 'Jacques'));
                  }
                });
              }),
              child: Text('Add dq'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(Icons.favorite),
          ),
        ],
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
