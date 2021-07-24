import 'dart:convert';

Tokenestatus tokenestatusFromJson(String str) =>
    Tokenestatus.fromJson(json.decode(str));

String tokenestatusToJson(Tokenestatus data) => json.encode(data.toJson());

class Tokenestatus {
  Tokenestatus({
    this.token,
  });

  String token;

  factory Tokenestatus.fromJson(Map<String, dynamic> json) => Tokenestatus(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
