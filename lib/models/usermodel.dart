// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    List<User> users;

    UserModel({
        required this.users,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    String username;
    String emailId;
    String password;

    User({
        required this.username,
        required this.emailId,
        required this.password,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        emailId: json["emailID"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "emailID": emailId,
        "password": password,
    };
}
