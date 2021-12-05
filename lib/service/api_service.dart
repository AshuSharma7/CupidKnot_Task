import 'dart:convert';
import 'dart:io';

import 'package:cupidknot/constants/endpoints.dart';
import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/service/status.dart';
import 'package:cupidknot/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  dynamic getResponse(String endpoint) async {
    try {
      print(access_token);
      var response =
          await http.get(Uri.parse(baseUrl + "/$endpoint"), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + access_token,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        return Success(response: jsonDecode(response.body));
      } else {
        throw Exception("Unable to perform request!");
      }
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }

  dynamic postResponse(String endpoint, dynamic body) async {
    try {
      var response = await http.post(Uri.parse(baseUrl + "/$endpoint"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + access_token,
          },
          body: body);
      print(response.body);
      if (response.statusCode == 200) {
        return Success(response: jsonDecode(response.body));
      } else {
        throw Exception("Unable to perform request!");
      }
    } on SocketException {
      return Failure(code: 101, response: "No Internet");
    } catch (e) {
      return Failure(code: 102, response: "Unknown Error $e");
    }
  }
}
