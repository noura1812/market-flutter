import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirydate;
  String? userid;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<String?> _authenticate(
      String email, String passwor, String urlSegment) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyACdvdeH-L4HrBDW4Da_8oe7EeI7Yegc-Q';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': passwor,
            'returnSecureToken': true
          }));
      final resdata = json.decode(res.body);
      if (resdata['error'] != null) {
        throw resdata['error']['message'].toString();
      }

      _token = resdata['idToken'];
      userid = resdata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(resdata['expiresIn'])));
      notifyListeners();
      return userid;
    } catch (e) {
      throw e;
    }
  }

  Future<String?> signup(String email, String passwor) async {
    return _authenticate(email, passwor, 'signUp');
  }

  Future<String?> signin(String email, String passwor) async {
    return _authenticate(email, passwor, 'signInWithPassword');
  }

  logout() {
    _token = null;
    userid = null;
    _expirydate = null;
    notifyListeners();
  }
}
