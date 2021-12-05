import 'package:cupidknot/constants/endpoints.dart';
import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/service/api_service.dart';
import 'package:cupidknot/service/status.dart';
import 'package:flutter/material.dart';

class UserListViewModel extends ChangeNotifier {
  bool _loading = false;
  String? loadingError;
  String? _error;
  bool _isNextLoading = false;

  bool get isNextLoading => _isNextLoading;

  setNextLoading(loading) {
    _isNextLoading = loading;
    notifyListeners();
  }

  int _currentPage = 1;
  int? _lastPage;
  String? nextUrl;

  List<dynamic> users = [];

  addUsersToList(list) {
    users = users..addAll(list);
  }

  UserListViewModel() {
    getFirstList();
  }

  int get currentPage => _currentPage;
  int? get lastPage => _lastPage;

  setCurrentPage(page) {
    _currentPage = page;
  }

  setLastPage(page) {
    _lastPage = page;
  }

  bool get loading => _loading;
  String? get error => _error;

  setLoading(loading) {
    _loading = loading;
    notifyListeners();
  }

  setError(String? error) {
    _error = error;
  }

  getFirstList() async {
    setLoading(true);
    var res = await ApiService().getResponse("users");
    if (res is Success) {
      setCurrentPage(res.response["data"]["current_page"]);
      setLastPage(res.response["data"]["last_page"]);
      nextUrl = res.response["data"]["next_page_url"];
      List<dynamic> temp = res.response["data"]["data"]
          .map((x) => UserModel.fromJson(x))
          .toList();
      addUsersToList(temp);
    } else {
      // showErrorSnackBar(context, res.response.toString());
      setError(res.response.toString());
    }
    setLoading(false);
  }

  getNextList() async {
    if (currentPage == lastPage) {
      loadingError = "No More Data";
      notifyListeners();
      return;
    }
    setNextLoading(true);
    var res = await ApiService().getResponse("users?page=${currentPage + 1}");
    if (res is Success) {
      setCurrentPage(res.response["data"]["current_page"]);
      setLastPage(res.response["data"]["last_page"]);
      nextUrl = res.response["data"]["next_page_url"];
      List<dynamic> temp = res.response["data"]["data"]
          .map((x) => UserModel.fromJson(x))
          .toList();
      addUsersToList(temp);
    } else {
      // showErrorSnackBar(context, res.response.toString());
      setError(res.response.toString());
    }
    setNextLoading(false);
  }
}
