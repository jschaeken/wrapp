import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrapp/Screens/LoginScreen.dart';
import 'HomePage.dart';
import 'Screens/ProfileView.dart';
import 'firebase_options.dart';

bool isMobile = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isMobile = Platform.isIOS || Platform.isAndroid;
  isMobile
      ? await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform)
      : null;
  runApp(const MyApp());
  FirebaseAuth mAuth = FirebaseAuth.instance;
  User? user = mAuth.currentUser;
  if (user == null) {
    mAuth.signInAnonymously();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: _customColorScheme,
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) =>
            const MyHomePage(title: 'Welcome to the WR App', true),
        '/profile': (context) => ProfileView('const Test User', 0),
        '/loginScreen': (context) => LoginScreen(),
      },
    );
  }
}

ColorScheme _customColorScheme = ColorScheme(
  primary: Colors.black,
  secondary: Colors.grey.shade300,
  surface: Colors.grey.shade900,
  background: const Color.fromARGB(255, 38, 38, 38),
  error: Colors.black,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.blue,
  onBackground: Colors.white,
  onError: Colors.redAccent,
  brightness: Brightness.light,
);
