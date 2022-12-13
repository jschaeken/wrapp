import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wrapp/Screens/Betting.dart';
import 'package:wrapp/Screens/DQList.dart';
import 'package:wrapp/Screens/DomCodes.dart';
import 'package:wrapp/Screens/NewProfileView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wrapp/Screens/ai_chat.dart';
import 'package:wrapp/Screens/police_mode.dart';

import 'Screens/Voting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.isMobile, {Key? key, required this.title})
      : super(key: key);
  final String title;
  final bool isMobile;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> widgetList = [];

  List<String> baseNames = [
    'Jacques',
    'Carl',
    'Daniel',
    'Calem',
    'Harry',
    'Shane',
    'Sean',
    'Rory',
    'Eoin',
    'James',
  ];
  List<String> namePaths = [];

  static List<String> constantNames = [
    'Jacques',
    'Carl',
    'Daniel',
    'Calem',
    'Harry',
    'Shane',
    'Sean',
    'Rory',
    'Eoin',
    'James',
  ];

  List<String> imgPaths = [
    'https://media-exp1.licdn.com/dms/image/D4E03AQEqryHbQEfomg/profile-displayphoto-shrink_400_400/0/1666277454062?e=1674691200&v=beta&t=NlXxUiEe0ngVzbxixTkJWTbh3WcHTBzBRyt7avqp7mg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
    'https://i.ibb.co/mcqVr6v/gruMeme.jpg',
  ];

  List<Color> colorSwitches = [
    Colors.green,
    Colors.red,
    Colors.black,
    Colors.amber,
    Colors.deepPurple,
    Colors.blue,
  ];

  List<String> topics = [
    'Betting',
    'Dominos Codes',
    'DQs',
    'Voting',
    'Ai Chat',
    'Police Mode',
  ];

  List<Widget> pages = [];
  int counter = 0;
  List screens = [
    const Betting(),
    const DomCodes(),
    const DQList(),
    const Voting(),
    ChatPage(),
    PoliceMode(),
  ];

  late DatabaseReference usersDatabase;
  late DatabaseReference notiDatabase;
  Stream<DatabaseEvent>? usersStream;
  @override
  void initState() {
    super.initState();
    notiDatabase = FirebaseDatabase.instance.ref("notis");
    usersDatabase = FirebaseDatabase.instance.ref("users");
    usersStream = usersDatabase.orderByKey().limitToFirst(10).onValue;
    notiSet();
  }

  FirebaseMessaging? messaging;
  NotificationSettings? settings;

  void notiSet() async {
    messaging = FirebaseMessaging.instance;
    settings = await messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings!.authorizationStatus}');
  }

  void setNames(int i) async {
    final newPostKey = usersDatabase.push().key;
    final Map<String, Map> updates = {};
    final postData = {
      'name': constantNames[i],
    };
    print(postData);
    updates['/$newPostKey'] = postData;
    usersDatabase.update(updates);
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
                          title: const Text('WR Alert'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
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
                                    textControl.clear();
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        );
                      }),
                    );
                  })
            },
            icon: const Icon(Icons.notification_add),
          ),
        ],
      ),
      //Body
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: notiDatabase.orderByKey().limitToLast(1).onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data as DatabaseEvent).snapshot.value !=
                        null) {
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
                                  style: const TextStyle(
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
              const Divider(
                thickness: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: screens.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => screens[index]),
                        )
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorSwitches[index % colorSwitches.length],
                        ),
                        height: 50,
                        child: Center(
                            child: Text(
                          topics[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        )),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              ),
              const Divider(
                thickness: 3,
              ),
              Row(
                children: const [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 600,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: .7,
                      crossAxisCount: 2),
                  itemCount: baseNames.length,
                  itemBuilder: (context, i) => Center(
                    child: ProfileTile(
                      imagePath: imgPaths[i],
                      onPressed: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewProfileView(baseNames[i], i)),
                          )),
                      baseNames: baseNames,
                      index: i,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                //Navigator.pushReplacementNamed(context, '/loginScreen');
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'L O G  O U T',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    Key? key,
    required this.baseNames,
    required this.index,
    required this.onPressed,
    required this.imagePath,
  }) : super(key: key);

  final List<String> baseNames;
  final int index;
  final Function() onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () => onPressed(),
          child: Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    imagePath,
                  ),
                  fit: BoxFit.cover),
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  baseNames[index],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
