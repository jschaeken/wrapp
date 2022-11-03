import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewProfileView extends StatefulWidget {
  const NewProfileView({Key? key}) : super(key: key);

  @override
  State<NewProfileView> createState() => _NewProfileViewState();
}

class _NewProfileViewState extends State<NewProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //1
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () {
                  Navigator.pop(context);
                }),
            automaticallyImplyLeading: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/wrEnhanced.jpg',
                fit: BoxFit.fill,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(100, 100),
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
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
