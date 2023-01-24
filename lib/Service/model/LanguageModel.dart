// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';
LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));
String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.languageName,
    required this.languageBackground,
    required this.status,
    required this.image,
  });

  String id;
  String languageName;
  String languageBackground;
  String status;
  String image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    languageName: json["language_name"],
    languageBackground: json["language_background"],
    status: json["status"],
    image:json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_name": languageName,
    "language_background": languageBackground,
    "status": status,
    "image":image,
  };
}
