import 'package:flutter/material.dart';
import 'package:sogak/Widgets/CustomSliderThumb.dart';

int tiredRate = 5;

class SliderWidget extends StatefulWidget {
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("완전 피로",style: Theme.of(context).textTheme.bodyText1),
                Text("무난",style: Theme.of(context).textTheme.bodyText1,),
                Text("완전 개운",style: Theme.of(context).textTheme.bodyText1,),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
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
            child: Slider(
              value: tiredRate.toDouble(),
              onChanged: (double newValue) {
                setState(() {
                  tiredRate = newValue.toInt();
                  print(tiredRate);
                });
              },
              min: 0.0,
              max: 10.0,
              divisions: 10,
            ),
          ),
        ],
      ),
    );
  }
}

