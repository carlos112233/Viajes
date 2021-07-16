import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.operadorClave,
    required this.operadorNombre,
  });

  String operadorClave;
  String operadorNombre;

  factory User.fromJson(Map<String, dynamic> json) => User(
        operadorClave: json["OPERADOR_CLAVE"],
        operadorNombre: json["OPERADOR_NOMBRE"],
      );

  Map<String, dynamic> toJson() => {
        "OPERADOR_CLAVE": operadorClave,
        "OPERADOR_NOMBRE": operadorNombre,
      };
}
