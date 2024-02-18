import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "개발자 소개",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leadingWidth: 40.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/flame.gif'))),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "developerha0013@gmail.com",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Developer",
                    style:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Junha Park",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
