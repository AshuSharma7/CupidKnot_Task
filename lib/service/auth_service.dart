import 'dart:convert';
import 'dart:io';

import 'package:cupidknot/constants/endpoints.dart';
import 'package:cupidknot/service/status.dart';
import 'package:cupidknot/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  dynamic login(String username, String password) async {
    try {
      var res = await http.post(
          Uri.parse(
            "$baseUrl/login",
          ),
          body: {
            'username': username,
            'password': password,
          });
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        return Success(response: jsonDecode(res.body));
      } else if (res.statusCode == 400)
        return Failure(
            code: 100, response: "Invalid Email or password Combination");
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }

  dynamic register(dynamic body) async {
    try {
      print(body);
      var res = await http.post(Uri.parse("$baseUrl/register"), body: body);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        return Success(response: jsonDecode(res.body));
      } else if (res.statusCode == 400)
        return Failure(code: 100, response: "Invalid Details");
      else if (res.statusCode == 302)
        return Failure(code: 100, response: "Email is already used");
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }

  dynamic refreshToken(dynamic body) async {
    try {
      print(body);
      var res = await http.post(Uri.parse("$baseUrl/refresh"), body: body);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        return Success(response: jsonDecode(res.body));
      } else if (res.statusCode == 400)
        return Failure(code: 100, response: "Invalid Details");
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }

  dynamic logout() async {
    try {
      var res = await http.post(Uri.parse("$baseUrl/logout"), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + access_token,
      });
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        return Success(response: jsonDecode(res.body));
      } else if (res.statusCode == 400)
        return Failure(code: 100, response: "Invalid Request");
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }
}
