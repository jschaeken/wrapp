import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Screens/ProfileView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: _customColorScheme,
      ),
      home: const MyHomePage(title: 'Welcome to the WR App'),
      routes: {
        '/profile': (context) => ProfileView('const Test User'),
      },
    );
  }
}

const ColorScheme _customColorScheme = ColorScheme(
  primary: Colors.black,
  secondary: Colors.grey,
  surface: Colors.purpleAccent,
  background: Colors.blueGrey,
  error: Colors.black,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.blue,
  onBackground: Colors.blue,
  onError: Colors.redAccent,
  brightness: Brightness.light,
);
