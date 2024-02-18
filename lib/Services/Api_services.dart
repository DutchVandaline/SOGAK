import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService{
  static Future<List<dynamic>?>? getData() async {
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
        return [];
      }
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  static Future<List<dynamic>?>? getMonthlyData(String inputDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https('sogak-api-nraiv.run.goorm.site',
        '/api/feeling/feelings/get_monthly_feelings/$inputDate');
    var response =
    await http.get(url, headers: {'Authorization': 'Token $_userToken'});

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        return responseData;
      } else {
        return [];
      }
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  static Future<Map<String, dynamic>?> getRecentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
    var response = await http.get(url, headers: {'Authorization': 'Token $_userToken'});

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        return responseData.first as Map<String, dynamic>;
      } else {
        return null;
      }
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  static Future<List<dynamic>?>? getMovetoSogakData() async {
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

  static Future<dynamic>? selectedSogakData(int inputId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https(
        'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$inputId');
    var response =
    await http.get(url, headers: {'Authorization': 'Token $_userToken'});

    if (response.statusCode == 200) {
      dynamic responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        print(responseData);
        return responseData;
      } else {
        return null;
      }
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  static Future<void> backToList(int _inputId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https(
        'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
    var response = await http.patch(url, headers: {
      'Authorization': 'Token $_userToken'
    }, body: {
      "movetosogak_bool": 'false',
    });
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
    }
  }

  static Future<void> patchMoodtoSogak(int _inputId, String _afterMemo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https(
        'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
    var response = await http.patch(url, headers: {
      'Authorization': 'Token $_userToken'
    }, body: {
      "movetosogak_bool": 'false',
      "sogak_bool": 'true',
      "after_memo": _afterMemo
    });
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
    }
  }
}