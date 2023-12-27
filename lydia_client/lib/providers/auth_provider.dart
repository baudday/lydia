import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lydia_client/models/user.dart';

class AuthProvider extends ChangeNotifier {
  String? _jwt;

  String? get jwt => _jwt;
  User? get user => _parseJwt(_jwt);
  bool get isAuthenticated => user != null;

  void signIn(String jwt) {
    _jwt = jwt;
    notifyListeners();
  }

  void signOut() {
    _jwt = null;
    notifyListeners();
  }

  User? _parseJwt(String? token) {
    if (token == null) {
      return null;
    }

    final parts = token.split('.');

    if (parts.length != 3) {
      _jwt = null;
      return null;
    }

    final normalized = base64Url.normalize(parts[1]);
    return User.fromRawJson(utf8.decode(base64Url.decode(normalized)));
  }
}
