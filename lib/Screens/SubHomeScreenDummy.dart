import 'package:flutter/material.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SubHomeScreenDummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).cardColor,
              child: Center(
                child: SfCircularChart(
                  title: const ChartTitle(
                      text: "감정을 추가하세요", alignment: ChartAlignment.center),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.left,
                    isResponsive: true,
                  ),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                        explode: true,
                        explodeIndex: 0,
                        dataSource: [
                          _PieData("매우 만족", 1),
                          _PieData("만족", 1),
                          _PieData("보통", 1),
                          _PieData("불만족", 1),
                          _PieData("매우 불만족", 1),
                        ],
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) => data.text,
                        dataLabelSettings: const DataLabelSettings(isVisible: true)),
                  ],
                  palette: const [
                    Color.fromRGBO(246, 114, 128, 1),
                    Color.fromRGBO(255, 205, 96, 1),
                    Color.fromRGBO(116, 180, 155, 1),
                    Color.fromRGBO(0, 168, 181, 1),
                    Color.fromRGBO(73, 76, 162, 1),
                  ],
                ),
              ),
            ),
          ),
          const Flexible(
              flex: 1,
              child: HomeScreenUnderWidget(
                  inputWidget:
                      Text("아직 발생한 일이 없습니다.\n감정을 추가하려면 + 버튼을 누르세요.",textAlign: TextAlign.center,))),
          const Flexible(
            flex: 1,
            child: HomeScreenUnderWidget(
              inputWidget: Text("아직 추가된 감정이 없습니다.\n감정을 추가하려면 + 버튼을 누르세요.",textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  String? text;
}
