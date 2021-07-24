// To parse this JSON data, do
//
//     final insertPosition = insertPositionFromJson(jsonString);

import 'dart:convert';

InsertPosition insertPositionFromJson(String str) =>
    InsertPosition.fromJson(json.decode(str));

String insertPositionToJson(InsertPosition data) => json.encode(data.toJson());

class InsertPosition {
  InsertPosition({
    this.mensaje,
  });

  String mensaje;

  factory InsertPosition.fromJson(Map<String, dynamic> json) => InsertPosition(
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "mensaje": mensaje,
      };
}
