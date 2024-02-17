import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class ChartWidget extends StatefulWidget {
  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

Future<List<Map<String, dynamic>>>? getMonthlyData(String month) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/count_by_month/$month');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    List<Map<String, dynamic>> monthlyData = List.from(responseData);
    if (monthlyData.isNotEmpty) {
      print(monthlyData);
      return monthlyData;
    } else {
      return monthlyData;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM').format(now);
    String titleMonth = DateFormat('M').format(now);
    return FutureBuilder<List<Map<String, dynamic>>?>(
        future: getMonthlyData(formatDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.white,);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('아직 추가된 감정이 없습니다.');
          } else {
            List<Map<String, dynamic>> monthlyData = snapshot.data!;
            return SfCircularChart(
              title: ChartTitle(
                  text: "$titleMonth월의 감정", alignment: ChartAlignment.center),
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
                      _PieData("매우 만족", monthlyData[4]['count']),
                      _PieData("만족", monthlyData[3]['count']),
                      _PieData("보통", monthlyData[2]['count']),
                      _PieData("불만족", monthlyData[1]['count']),
                      _PieData("매우 불만족", monthlyData[0]['count']),
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
            );
          }
        });
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  String? text;
}

String getMoodText(int baseMood) {
  // Map base mood values to corresponding text
  switch (baseMood) {
    case 0:
      return '행복한';
    case 1:
      return '흥분되는';
    case 2:
      return '사랑스러운';
    case 3:
      return '슬픈';
    case 4:
      return '분노하는';
    case 5:
      return '혐오스러운';
    case 6:
      return '공포스러운';
    default:
      return 'Unknown Mood';
  }
}
