import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileView extends StatefulWidget {
  String name;
  int index;

  ProfileView(this.name, this.index, {Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Image? image;
  XFile? _image;
  late Reference profilePhotosStorage;
  DatabaseReference? usersPfpRef;
  String? parentKey;
  String imageUrl = 'https://i.ibb.co/LYWq2R3/doggo.jpg';
  @override
  void initState() {
    super.initState();
    profilePhotosStorage = FirebaseStorage.instance.ref("pfps");
    getPfp(widget.index);
  }

  void getPfp(int i) async {
    usersPfpRef = FirebaseDatabase.instance.ref('users/');
    final data = await usersPfpRef!.get();
    print(data.value);
    final map = Map<dynamic, dynamic>.from(data.value as Map<dynamic, dynamic>);
    parentKey;
    int count = 0;
    map.forEach((key, value) {
      if (count == i) {
        parentKey = key.toString();
      }
      count++;
    });
    usersPfpRef = FirebaseDatabase.instance.ref("users/$parentKey");
    if (usersPfpRef != null) {
      final snapshot = await usersPfpRef!.child('/profilePicUrl').get();
      if (snapshot.exists) {
        imageUrl = snapshot.value.toString();
      }
    }
  }

  Future<String> uploadPhoto(XFile file) async {
    final newPostRef = profilePhotosStorage
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    try {
      await newPostRef.putFile(
        File(file.path),
      );
      return await newPostRef.getDownloadURL();
    } catch (e) {
      print(e);
      return 'https://i.ibb.co/LYWq2R3/doggo.jpg';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 4 / 3,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<Object>(
                  stream: FirebaseDatabase.instance
                      .ref("users/$parentKey;")
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data as DatabaseEvent).snapshot.value !=
                          null) {
                        final data = Map<dynamic, dynamic>.from(
                            (snapshot.data as DatabaseEvent).snapshot.value
                                as Map<dynamic, dynamic>);
                        imageUrl = data['profilePicUrl'];
                      }
                    }
                    return Container(
                      decoration: BoxDecoration(
                          image:
                              DecorationImage(image: NetworkImage(imageUrl))),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          ImagePicker _picker = ImagePicker();
                                          // Pick an image
                                          _image = await _picker.pickImage(
                                              source: ImageSource.camera);
                                          if (_image != null) {
                                            imageUrl =
                                                await uploadPhoto(_image!);
                                            usersPfpRef!.update(
                                                {'profilePicUrl': '$imageUrl'});
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      image == null
                                          ? const SizedBox()
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
