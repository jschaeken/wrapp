// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:wrapp/Screens/EmailSignIn.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  String login = 'L O G I N', register = 'R E G I S T E R';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Center(
            child: Image.asset(
              'assets/images/wrLogo.png',
              scale: 1.5,
            ),
          ),
          const Spacer(),
          LoginPageButton(
            text: login,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const EnterCode())),
          ),
          const SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }
}

class EnterCode extends StatefulWidget {
  const EnterCode({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  int focusTile = 0;

  TextEditingController controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController(),
      controller4 = TextEditingController();

  late List<TextEditingController> cntrlList;
  late final node;
  @override
  void initState() {
    super.initState();
    cntrlList = [
      controller1,
      controller2,
      controller3,
      controller4,
    ];
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    List<String> code = [];
    for (var element in cntrlList) {
      code.add(element.text);
    }
    final finalCode = code.join();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          iconSize: 30,
          color: Theme.of(context).colorScheme.background,
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 1,
          ),
          const Center(
            child: Text('E N T E R   I N V I T E   C O D E'),
          ),
          Column(children: [
            SizedBox(
                width: 400,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DigitEntryBox(
                      callback: () => node.nextFocus(),
                      controller: controller1,
                      focus: focusTile == 0,
                    ),
                    DigitEntryBox(
                      callback: () => node.nextFocus(),
                      controller: controller2,
                      focus: focusTile == 1,
                    ),
                    DigitEntryBox(
                      callback: () => node.nextFocus(),
                      controller: controller3,
                      focus: focusTile == 2,
                    ),
                    DigitEntryBox(
                      callback: () {
                        node.nextFocus();
                        setState(() {});
                      },
                      controller: controller4,
                      focus: focusTile == 3,
                    ),
                  ],
                )),
          ]),
          const Spacer(),
          finalCode == '9999'
              ? LoginPageButton(
                  text: 'Enter',
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const EmailSignIn()));
                  })
              : const SizedBox(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class DigitEntryBox extends StatelessWidget {
  DigitEntryBox({
    Key? key,
    required this.focus,
    required this.controller,
    required this.callback,
  }) : super(key: key);
  bool focus;
  TextEditingController controller;
  Function() callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.bottomCenter,
        width: 60,
        height: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) => value.isNotEmpty ? callback() : null,
            textInputAction: TextInputAction.next,
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 70),
            showCursor: false,
            autofocus: focus,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: -2.0, bottom: 0.0, top: -10.0, right: 0),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: '1',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPageButton extends StatelessWidget {
  const LoginPageButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
