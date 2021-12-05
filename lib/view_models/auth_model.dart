import 'package:cupidknot/constants/endpoints.dart';
import 'package:cupidknot/service/api_service.dart';
import 'package:cupidknot/service/auth_service.dart';
import 'package:cupidknot/service/status.dart';
import 'package:cupidknot/view/login.dart';
import 'package:cupidknot/user.dart';
import 'package:cupidknot/view/users.dart';
import 'package:cupidknot/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  bool _loading = false;
  String _error = "";

  bool get loading => _loading;
  String get error => _error;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setError(String error) {
    _error = error;
  }

  setToken(dynamic res) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("access_token", res.response["access_token"]);
    access_token = res.response["access_token"];
    print(access_token);
    refresh_token = res.response["refresh_token"];
    preferences.setString("refresh_token", res.response["refresh_token"]);
  }

  getRefresh() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("refresh_token");
  }

  checkUser(context, String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      showWarningSnack(context, "All fields are mandatory");
      return;
    }
    setLoading(true);
    var res = await AuthService().login(username, password);
    print(res.response);

    if (res is Success) {
      setToken(res);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UsersList()),
          (route) => false);
    } else {
      showErrorSnackBar(context, res.response.toString());
    }

    setLoading(false);
  }

  createUser(context, dynamic body) async {
    setLoading(true);
    var res = await AuthService().register(body);
    print(res.response);

    if (res is Success) {
      setToken(res);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UsersList()),
          (route) => false);
    } else {
      showErrorSnackBar(context, res.response.toString());
    }

    setLoading(false);
  }

  checkCurrentUser(
    context,
  ) async {
    var ref = await getRefresh();
    if (ref == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    var res = await AuthService().refreshToken({"refresh_token": ref});
    setToken(res);
    print(res.response);

    if (res is Success) {
      setToken(res);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UsersList()),
          (route) => false);
    } else {
      showErrorSnackBar(context, res.response.toString());
    }
  }

  logout(
    context,
  ) async {
    var res = await AuthService().logout();
    setToken(res);
    print(res.response);

    if (res is Success) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      showErrorSnackBar(context, res.response.toString());
    }
  }
}
