import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wrapp/HomePage.dart';
import 'package:wrapp/Screens/LoginScreen.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage(true, title: '${snapshot.data!.email}');
          }
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: emailController,
                    isEmail: true,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordController,
                    isEmail: false,
                    hintText: 'Password',
                  ),
                  LoginPageButton(
                    text: 'S I G N   I N',
                    onPressed: () {
                      login();
                    },
                  ),
                ],
              ));
        });
  }

  void login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) => print(value));
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.isEmail,
    required this.hintText,
  }) : super(key: key);

  final controller;
  final isEmail;
  final hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        // alignment: Alignment.bottomCenter,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: controller,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.surface),
            obscureText: !isEmail,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
