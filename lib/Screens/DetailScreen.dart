import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/SubDetailScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sogak/Services/Api_services.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.inputId}) : super(key: key);

  final int inputId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

Future<dynamic>? getDatabyId(int inputId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$inputId/');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData;
    } else {
      return null;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}



class _DetailScreenState extends State<DetailScreen> {
  static Future<void> patchMovetoSogak(int _inputId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https(
        'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
    var response = await http.patch(url, headers: {
      'Authorization': 'Token $_userToken'
    }, body: {
      "movetosogak_bool": 'true',
    });
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("세부 감정 🔍"),
        actions: [
          IconButton(
              onPressed: () {
                patchMovetoSogak(widget.inputId);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "소각로로 이동했습니다. 소각로에서 확인해주세요.",
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0),
                  ),
                  duration: Duration(seconds: 2),
                ));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.local_fire_department_outlined)),
          IconButton(
              onPressed: () {
                ApiService.deleteMood(widget.inputId);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getDatabyId(widget.inputId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("이미 삭제되었거나\n불러오는데 오류가 발생했습니다."),
              );
            } else {
              var SogakData = snapshot.data;
              print(SogakData);
              if (SogakData != null) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DetailSubScreen(inputData: SogakData),
                );
              } else {
                return const Text('No data available');
              }
            }
          },
        ),
      ),
    );
  }
}
