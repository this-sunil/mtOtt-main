// To parse this JSON data, do
//
//     final runingSongModel = runingSongModelFromJson(jsonString);

import 'dart:convert';

RuningSongModel runingSongModelFromJson(String str) => RuningSongModel.fromJson(json.decode(str));

String runingSongModelToJson(RuningSongModel data) => json.encode(data.toJson());

class RuningSongModel {
  RuningSongModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory RuningSongModel.fromJson(Map<String, dynamic> json) => RuningSongModel(
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
    required this.name,
    required this.category,
    required this.type,
    required this.image,
    required this.deleted,
    required this.status,
  });

  String id;
  String name;
  String category;
  String type;
  String image;
  String deleted;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    category: json["category"],
    type: json["type"],
    image: json["image"],
    deleted: json["deleted"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "type": type,
    "image": image,
    "deleted": deleted,
    "status": status,
  };
}
