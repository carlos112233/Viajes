import 'dart:convert';

Respuesta respuestaFromJson(String str) => Respuesta.fromJson(json.decode(str));

String respuestaToJson(Respuesta data) => json.encode(data.toJson());

class Respuesta {
  Respuesta({
    this.mensaje,
    this.token,
  });

  String mensaje;
  int token;

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        mensaje: json["mensaje"],
        token: json["Token"],
      );

  Map<String, dynamic> toJson() => {
        "mensaje": mensaje,
        "Token": token,
      };
}
