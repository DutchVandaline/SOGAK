import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatefulWidget {
  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: "1월의 감정", alignment: ChartAlignment.center),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.left,
        isResponsive: true,
      ),
      series: <PieSeries<_PieData, String>>[
        PieSeries<_PieData, String>(
            explode: true,
            explodeIndex: 0,
            dataSource: [
              _PieData("행복한", 1),
              _PieData("흥분되는", 2),
              _PieData("사랑스러운", 2),
              _PieData("슬픈", 2),
              _PieData("분노하는", 2),
              _PieData("혐오스러운", 2),
              _PieData("공포스러운", 2),
            ],
            xValueMapper: (_PieData data, _) => data.xData,
            yValueMapper: (_PieData data, _) => data.yData,
            dataLabelMapper: (_PieData data, _) => data.text,
            dataLabelSettings: DataLabelSettings(isVisible: true)),
      ],
      palette: [
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(229, 229, 229, 1),
        Color.fromRGBO(193, 193, 193, 1),
        Color.fromRGBO(157, 157, 157, 1),
        Color.fromRGBO(121, 121, 121, 1),
        Color.fromRGBO(85, 85, 85, 1),
        Color.fromRGBO(49, 49, 49, 1),
      ],
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  String? text;
}
