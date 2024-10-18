import 'dart:convert';
import 'package:jadwal_vaksinasi/helpers/api.dart';
import 'package:jadwal_vaksinasi/helpers/api_url.dart';
import 'package:jadwal_vaksinasi/model/login.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};
    try {
      var response = await Api().post(apiUrl, body);
      print('Login Response: ${response.body}'); // For debugging
      var jsonObj = json.decode(response.body);
      return Login.fromJson(jsonObj);
    } catch (e) {
      print('Login Error: $e'); // For debugging
      return Login(code: 500, status: false, token: null, userID: null, userEmail: null);
    }
  }
}