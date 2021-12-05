import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.religion,
    required this.birthDate,
    required this.gender,
    required this.userImages,
  });

  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String firstName;
  String lastName;
  String religion;
  String birthDate;
  dynamic gender;
  List<String> userImages;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        religion: json["religion"].toString(),
        birthDate: json["birth_date"].toString(),
        gender: json["gender"],
        userImages: List<String>.from(
            json["user_images"].map((x) => x["path"] + x["name"])),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "religion": religion,
        "birth_date": birthDate,
        "gender": gender,
        "user_images": List<dynamic>.from(userImages.map((x) => x)),
      };
}
