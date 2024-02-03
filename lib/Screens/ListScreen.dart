import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';


class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

//TODO:add token. first, implement the database to store token.
// Future<Map<String, dynamic>?> getData(String _userToken) async {
//   var url =
//   Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
//   var response =
//   await http.get(url, headers: {'Authorization': 'Token $_userToken'});
//
//   if (response.statusCode == 200) {
//     List<dynamic> responseData = json.decode(response.body);
//     if (responseData.isNotEmpty) {
//       return responseData.last as Map<String, dynamic>;
//     } else {
//       return null; // Return null if the list is empty
//     }
//   } else {
//     throw Exception('Error: ${response.statusCode}, ${response.body}');
//     return null;
//   }
// }

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Moods 👏",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ListViewWidget(),
        ],
      ),
    );
  }
}




