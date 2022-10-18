import 'package:flutter/material.dart';
import 'package:wrapp/Screens/BetView.dart';

class Betting extends StatefulWidget {
  const Betting({Key? key}) : super(key: key);

  @override
  State<Betting> createState() => _BettingState();
}

class _BettingState extends State<Betting> {
  List<String> betsList = [
    'Bet 1',
    'Bet 2',
    'Bet 3',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Betting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BetView()));
                      },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)),
                      child: Text(
                        betsList[index],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ));
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: betsList.length),
          ],
        ),
      ),
    );
  }
}
