// To parse this JSON data, do
//
//     final weatherErrorModel = weatherErrorModelFromJson(jsonString);

import 'dart:convert';

WeatherErrorModel weatherErrorModelFromJson(String str) => WeatherErrorModel.fromJson(json.decode(str));

String weatherErrorModelToJson(WeatherErrorModel data) => json.encode(data.toJson());

class WeatherErrorModel {
  dynamic cod;
  String message;

  WeatherErrorModel({
    required this.cod,
    required this.message,
  });

  factory WeatherErrorModel.fromJson(Map<String, dynamic> json) => WeatherErrorModel(
        cod: json["cod"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "cod": cod,
        "message": message,
      };
}
