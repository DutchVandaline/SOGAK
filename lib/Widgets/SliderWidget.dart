import 'package:flutter/material.dart';
import 'package:sogak/Widgets/CustomSliderThumb.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({required this.inputSlider});

  final Widget inputSlider;


  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 17.0,),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: RectangularSliderTrackShape(),
              thumbShape: RoundSliderThumbShape(),
              thumbColor: Colors.red,
              overlayShape: SliderComponentShape.noOverlay,
              valueIndicatorShape: SliderComponentShape.noOverlay,
              inactiveTrackColor: Colors.white,
              activeTrackColor: Colors.red,
              trackHeight: 7.0,
            ),
            child: widget.inputSlider
          ),
        ],
      ),
    );
  }
}

