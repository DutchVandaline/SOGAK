import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: change style in list screen. ui change

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
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

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Moods 👏",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("불러오는데 에러가 발생했습니다.");
          } else {
            List<dynamic> FeelingDatum =
            snapshot.data as List<dynamic>;
            if (FeelingDatum != null) {
              return ListView.builder(
                itemCount: FeelingDatum.length,
                itemBuilder: (context, index) {
                  print(FeelingDatum[index]);
                  return ListViewWidget(
                    inputData: FeelingDatum[index]);
                }
              );
            } else {
              return Text('No data available');
            }
          }
        },),);
  }
}
