class Success {
  int? code;
  dynamic response;
  Success({this.code, required this.response});
}

class Failure {
  int code;
  dynamic response;
  Failure({required this.code, required this.response});
}
