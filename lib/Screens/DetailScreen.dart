import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//TODO: create detail Screen
class DetailScreen extends StatefulWidget {
  DetailScreen({required this.inputId});
  final int inputId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

Future<List<dynamic>?>? getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url =
  Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response =
  await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.inputId.toString()),
        ],
      ),
    );
  }
}
