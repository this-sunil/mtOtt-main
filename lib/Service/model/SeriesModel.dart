// To parse this JSON data, do
//
//     final seriesModel = seriesModelFromJson(jsonString);

import 'dart:convert';

SeriesModel seriesModelFromJson(String str) => SeriesModel.fromJson(json.decode(str));

String seriesModelToJson(SeriesModel data) => json.encode(data.toJson());

class SeriesModel {
  SeriesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
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
    required this.seriesId,
    required this.seasonName,
    required this.status,
  });

  String id;
  String seriesId;
  String seasonName;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    seriesId: json["series_id"],
    seasonName: json["season_name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "series_id": seriesId,
    "season_name": seasonName,
    "status": status,
  };
}
