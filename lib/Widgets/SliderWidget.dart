import 'package:flutter/material.dart';
import 'package:sogak/Widgets/CustomSliderThumb.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({required this.inputText1, required this.inputText2, required this.inputText3, required this.inputSlider});
  final String inputText1;
  final String inputText2;
  final String inputText3;
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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.inputText1,style: Theme.of(context).textTheme.bodyText1),
                Text(widget.inputText2,style: Theme.of(context).textTheme.bodyText1,),
                Text(widget.inputText3,style: Theme.of(context).textTheme.bodyText1,),
              ],
            ),
          ),
          SizedBox(height: 17.0,),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: RectangularSliderTrackShape(),
              thumbShape: CustomSliderThumbRect(
                  thumbRadius: 4.0,
                  min: 0,
                  max: 10,
                  thumbHeight: 50.0),
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

