//Estructura de datos para almacenar los datos del login
// To parse this JSON data, do
//
//     final loginJwt = loginJwtFromJson(jsonString);

import 'dart:convert';

LoginJwt loginJwtFromJson(String str) => LoginJwt.fromJson(json.decode(str));

String loginJwtToJson(LoginJwt data) => json.encode(data.toJson());

class LoginJwt {
  final String token;
  final String refreshToken;
  final int operatorId;
  final int wallet;

  LoginJwt({
    required this.token,
    required this.refreshToken,
    required this.operatorId,
    required this.wallet,
  });

  factory LoginJwt.fromJson(Map<String, dynamic> json) => LoginJwt(
        token: json["token"],
        refreshToken: json["refresh_token"],
        operatorId: json["operator_id"],
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "refresh_token": refreshToken,
        "operator_id": operatorId,
        "wallet": wallet,
      };
}

class LoginRequestModel {
  String? email;
  String? password;
  LoginRequestModel({
    this.email,
    this.password,
  });
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(email: "", password: "");
  Map<String, dynamic> toJson() => {
        "username": email,
        "password": password,
      };
}
