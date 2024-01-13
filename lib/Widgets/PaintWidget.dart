import 'package:flutter/material.dart';
import 'package:sogak/Widgets/MoodWidget.dart';

class PaintWidget extends StatefulWidget {
  @override
  State<PaintWidget> createState() => _PaintWidgetState();
}

class _PaintWidgetState extends State<PaintWidget> {
  Offset? _tapPosition;

  void _getTapPosition(TapDownDetails details) async {
    final tapPosition = details.globalPosition;
    setState(() {
      _tapPosition = tapPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _getTapPosition(details);
        print('X: ${_tapPosition?.dx.toStringAsFixed(2) ?? "Tap Somewhere"}');
        print('Y: ${_tapPosition?.dy.toStringAsFixed(2) ?? "Tap Somewhere"}');
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).canvasColor,
          ),
          child: Stack(
            children: [
              MoodWidget(
                inputColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
