import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hi! User",
          style: TextStyle(fontSize: 25.0),
        ),
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DetailWidget(
              inputHeight: 130.0,
              inputWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Mon, 19 JAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.arrow_drop_up,size: 100.0, color: Colors.red,),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget(
      {Key? key, required this.inputWidget, required this.inputHeight})
      : super(key: key);

  final Widget inputWidget;
  final double inputHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Center(
          child: inputWidget,
        ),
        height: inputHeight,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}
