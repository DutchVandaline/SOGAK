import 'package:flutter/foundation.dart';
import 'package:sogak/Database/Database.dart';


class TokenNotifier extends ChangeNotifier {
  List _tokens = [];

  List get tokens {
    return [..._tokens];
  }

  Future deleteMovie(String id) {
    _tokens.removeWhere((element) => element.id == id);
    notifyListeners();
    return DBHelper().deleteToken(id);
  }

  Future addToken(
      String id,
      String tokenName,
      ) async {
    final userToken = UserToken(
      id: id,
      tokenName: tokenName,
    );

    _tokens.insert(0, userToken);

    notifyListeners();

    DBHelper().insertToken(userToken);
  }

}
