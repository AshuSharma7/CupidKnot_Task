import 'dart:io';

import 'package:cupidknot/constants/endpoints.dart';
import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/service/api_service.dart';
import 'package:cupidknot/service/status.dart';
import 'package:cupidknot/user.dart';
import 'package:cupidknot/widgets/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserViewModel extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  UserModel? _user;
  bool uploadBool = false;

  UserViewModel() {
    fetchUser();
  }

  setUser(UserModel? model) {
    _user = model;
  }

  setError(error) {
    _error = error;
  }

  String? get error => _error;

  UserModel? get user => _user;

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<UserModel?> fetchUser() async {
    setLoading(true);
    var res = await ApiService().getResponse(Endpoints.currentUser);
    print(res.response);
    if (res is Success) {
      setUser(UserModel.fromJson(res.response));
    } else {
      // showErrorSnackBar(context, res.response.toString());
      setError("No Data");
    }
    setLoading(false);
  }

  updateUser(context, body) async {
    setLoading(true);
    print(body);
    var res = await ApiService().postResponse(Endpoints.updateUser, body);
    if (res is Success) {
      showSuccessSnackBar(context, "Profile Updated");
      fetchUser();
      Navigator.pop(context);
    } else {
      showErrorSnackBar(context, res.response.toString());
      setError("No Data");
    }
    setLoading(false);
  }

  selectImage(context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    uploadBool = true;
    Dio dio = Dio();
    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + access_token,
    };
    notifyListeners();
    FormData formData = new FormData.fromMap({
      "original_photo[]":
          await MultipartFile.fromFile(image.path, filename: image.name)
    });
    var response =
        await dio.post("$baseUrl/${Endpoints.uploadImage}", data: formData);

    print(response.statusCode);
    if (response.statusCode == 200) {
      showSuccessSnackBar(context, "Image Uploaded");
      fetchUser();

      uploadBool = false;
      notifyListeners();
    } else {
      showErrorSnackBar(context, "An Error Occurred while uploading");
      uploadBool = false;
      notifyListeners();
    }
  }
}
