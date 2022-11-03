import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewProfileView extends StatefulWidget {
  int index;
  String name;

  NewProfileView(this.name, this.index, {Key? key}) : super(key: key);

  @override
  State<NewProfileView> createState() => _NewProfileViewState();
}

class _NewProfileViewState extends State<NewProfileView> {
  String? parentKey;
  String? imageUrl;
  DatabaseReference? usersPfpRef;
  @override
  void initState() {
    super.initState();
    getPfp(widget.index);
  }

  void getPfp(int i) async {
    usersPfpRef = FirebaseDatabase.instance.ref('users/');
    final data = await usersPfpRef!.get();
    final map = Map<dynamic, dynamic>.from(data.value as Map<dynamic, dynamic>);
    int count = 0;
    map.forEach((key, value) {
      if (count == i) {
        parentKey = key.toString();
      }
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    getPfp(widget.index);
    return Scaffold(
      //1
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () {
                  Navigator.pop(context);
                }),
            automaticallyImplyLeading: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.name),
              background: FutureBuilder(
                future: FirebaseDatabase.instance.ref("users/$parentKey").get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = (snapshot.data as DataSnapshot);
                    if (data.exists) {
                      final map = Map<dynamic, dynamic>.from(
                          data.value as Map<dynamic, dynamic>);
                      map.forEach((key, value) {
                        if (key == 'profilePicUrl') {
                          imageUrl = value;
                        }
                      });
                    } else {
                      imageUrl = 'https://i.redd.it/2o4askcf60o81.jpg';
                    }
                  } else {
                    imageUrl = 'https://i.redd.it/2o4askcf60o81.jpg';
                  }
                  return snapshot.connectionState == ConnectionState.done
                      ? Image.network(
                          imageUrl ?? 'https://i.redd.it/2o4askcf60o81.jpg',
                          fit: BoxFit.cover,
                        )
                      : CircularProgressIndicator();
                },
              ),
            ),
          ),
          //3
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('Dq ${index + 1}'),
                          )),
                  title: Text('DQ ${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
