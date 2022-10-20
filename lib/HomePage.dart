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

  List<String> baseNames = [];

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
  late DatabaseReference notiDatabase;
  late Stream<DatabaseEvent> usersStream;
  @override
  void initState() {
    super.initState();
    notiDatabase = FirebaseDatabase.instance.ref("notis");
    usersDatabase = FirebaseDatabase.instance.ref("users");
    usersStream = usersDatabase.orderByKey().limitToFirst(10).onValue;
  }

  // Stream<DatabaseEvent> getNewStream() {
  //   return usersDatabase!
  //       .orderByKey()
  //       .limitToFirst(10)
  //       .onValue
  //       .asBroadcastStream(
  //     onCancel: (controller) {
  //       print('Stream cancelled');
  //       controller.cancel();
  //     },
  //   );
  // }

  void setNames(int i) async {
    usersDatabase.update({'Name ${i.toString()}': baseNames[i]});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textControl = TextEditingController();
    String lastNoti = '';
    String lastNotiName = '';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: ((context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('WR Alert'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelText: 'Alert',
                                    ),
                                    controller: textControl,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: const Text("Send Alert Message"),
                                onPressed: () {
                                  setState(() {
                                    final newPostKey = notiDatabase.push().key;
                                    final Map<String, Map> updates = {};
                                    final postData = {
                                      'text': textControl.text,
                                      'name': 'Jacques'
                                    };
                                    updates['/$newPostKey'] = postData;
                                    notiDatabase.update(updates);
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        );
                      }),
                    );
                  })
            },
            icon: Icon(Icons.notification_add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: notiDatabase.orderByKey().limitToLast(1).onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
                    final data = Map<dynamic, dynamic>.from(
                        (snapshot.data as DatabaseEvent).snapshot.value
                            as Map<dynamic, dynamic>);
                    data.forEach((key, value) {
                      var detail = Map<dynamic, dynamic>.from(value);
                      lastNoti = detail['text'];
                      lastNotiName = detail['name'];
                    });
                  }
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Latest Announcement from $lastNotiName'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                lastNoti,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
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
              child: FutureBuilder(
                  future: usersDatabase.orderByKey().limitToFirst(10).get(),
                  builder: (context, event) {
                    baseNames.clear();
                    Map<dynamic, dynamic>? dataMap;
                    if (event.hasData) {
                      dataMap = (event.data as DataSnapshot).value
                          as Map<dynamic, dynamic>;
                      dataMap.forEach((key, value) {
                        print(value);
                        baseNames.add(value);
                      });
                    }
                    return (event.connectionState != ConnectionState.done)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Center(child: Text(baseNames[index])),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            ),
                          ));
                  }),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Favorites',
      //       icon: Icon(Icons.favorite),
      //     ),
      //   ],
      // ),
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
