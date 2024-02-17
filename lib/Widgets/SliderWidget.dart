import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key, required this.inputSlider}) : super(key: key);

  final Widget inputSlider;


  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 17.0,),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const RectangularSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(),
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

