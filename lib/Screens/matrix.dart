import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernUILogin extends StatefulWidget {
  const ModernUILogin({Key? key}) : super(key: key);

  @override
  State<ModernUILogin> createState() => _ModernUILoginState();
}

class _ModernUILoginState extends State<ModernUILogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool entryPossible = false;

  String publictext = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: [
                Text(publictext,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.shareTechMono(
                        color: const Color.fromARGB(255, 22, 221, 29),
                        fontSize: 30)),
              ],
            ),
            const Spacer(),
            entryPossible
                ? GestureDetector(
                    child: const Icon(
                      Icons.cruelty_free_outlined,
                      color: Color.fromARGB(255, 22, 221, 29),
                      size: 50,
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PinLogin())),
                  )
                : const SizedBox(),
            const Spacer(),
            entryPossible
                ? const SizedBox()
                : TextButton(
                    onPressed: () => letterAnimation(
                      fulltext: 'Hello Jacques, Welcome to the Matrix',
                      textCallback: (text) => setState(() {
                        publictext = text;
                      }),
                      completedCallback: () => setState(() {
                        entryPossible = true;
                      }),
                    ),
                    child: Text(
                      'Enter',
                      style: GoogleFonts.shareTechMono(
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                        color: const Color.fromARGB(255, 22, 221, 29),
                      ),
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
            ),
          ]),
    );
  }
}

Future<String> letterAnimation(
    {required String fulltext,
    required Function(String text) textCallback,
    required Function completedCallback,
    int? startDelayMilli}) async {
  String text = '';
  startDelayMilli ?? 0;
  await Future.delayed(Duration(milliseconds: startDelayMilli!));
  for (int i = 0; i < fulltext.length; i++) {
    text += fulltext[i];
    textCallback(text);
    await Future.delayed(const Duration(milliseconds: 40));
  }
  await Future.delayed(const Duration(milliseconds: 200));
  completedCallback();
  return text;
}

//make a page with to login with a pin
class PinLogin extends StatefulWidget {
  const PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  List<int> pindigit = [0, 0, 0, 0];
  String enterPin = 'Enter Pin';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    letterAnimation(
        fulltext: enterPin,
        textCallback: (text) {
          setState(() {
            enterPin = text;
          });
        },
        completedCallback: () {},
        startDelayMilli: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: [
                Text(enterPin,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.shareTechMono(
                        color: const Color.fromARGB(255, 22, 221, 29),
                        fontSize: 30)),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinBox(
                    pindigit: pindigit[0].toString(),
                    callback: () => incrementPin(0)),
                const SizedBox(width: 10),
                PinBox(
                    pindigit: pindigit[1].toString(),
                    callback: () => incrementPin(1)),
                const SizedBox(width: 10),
                PinBox(
                    pindigit: pindigit[2].toString(),
                    callback: () => incrementPin(2)),
                const SizedBox(width: 10),
                PinBox(
                    pindigit: pindigit[3].toString(),
                    callback: () => incrementPin(3)),
                const SizedBox(width: 10),
              ],
            ),
            const Spacer(),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: BackButton(ctx: context)),
          ]),
    );
  }

  void incrementPin(int i) {
    String pinCheck = '';
    setState(() {
      pindigit[i] = (pindigit[i] += 1) % 10;
    });
    for (int i = 0; i < pindigit.length; i++) {
      pinCheck += pindigit[i].toString();
    }
    if (pinCheck == '1111') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Matrix()));
    }
  }
}

class PinBox extends StatelessWidget {
  const PinBox({
    Key? key,
    required this.pindigit,
    required this.callback,
  }) : super(key: key);

  final String pindigit;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 22, 221, 29)),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            pindigit,
            style: GoogleFonts.shareTechMono(
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 22, 221, 29), fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class Matrix extends StatefulWidget {
  const Matrix({Key? key}) : super(key: key);

  @override
  State<Matrix> createState() => _MatrixState();
}

class _MatrixState extends State<Matrix> {
  String welcomeText = 'Hello Jacques, Welcome Home';
  bool animationDone = false;
  List<String> topics = ['Notes', 'Music', 'Games', 'Settings'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    letterAnimation(
        fulltext: welcomeText,
        textCallback: (text) {
          setState(() {
            welcomeText = text;
          });
        },
        completedCallback: () {
          setState(() {
            animationDone = true;
          });
        },
        startDelayMilli: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //make a matrix like background
      body: animationDone
          ? Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  children: [
                    for (int i = 0; i < topics.length; i++)
                      UnderlinedButton(topic: topics[i]),
                    BackButton(ctx: context),
                  ],
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                const SizedBox(height: 10),
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(welcomeText,
                        style: GoogleFonts.shareTechMono(
                          textStyle: const TextStyle(
                              color: Color.fromARGB(255, 22, 221, 29),
                              fontSize: 20),
                        )),
                  ),
                ),
                const Spacer(),
                BackButton(
                  ctx: context,
                ),
              ],
            ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(ctx),
      child: Text(
        'Back',
        style: GoogleFonts.shareTechMono(
          decoration: TextDecoration.underline,
          fontSize: 20,
          color: const Color.fromARGB(255, 22, 221, 29),
        ),
      ),
    );
  }
}

class UnderlinedButton extends StatelessWidget {
  const UnderlinedButton({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final String topic;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {},
      child: Text(
        topic,
        style: GoogleFonts.shareTechMono(
          decoration: TextDecoration.underline,
          fontSize: 20,
          color: const Color.fromARGB(255, 22, 221, 29),
        ),
      ),
    );
  }
}
