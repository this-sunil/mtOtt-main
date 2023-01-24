// To parse this JSON data, do
//
//     final genresModel = genresModelFromJson(jsonString);

import 'dart:convert';

GenresModel genresModelFromJson(String str) => GenresModel.fromJson(json.decode(str));

String genresModelToJson(GenresModel data) => json.encode(data.toJson());

class GenresModel {
  GenresModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory GenresModel.fromJson(Map<String, dynamic> json) => GenresModel(
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
    required this.gid,
    required this.genreName,
    required this.genreImage,
  });

  String gid;
  String genreName;
  String genreImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    gid: json["gid"],
    genreName: json["genre_name"],
    genreImage: json["genre_image"],
  );

  Map<String, dynamic> toJson() => {
    "gid": gid,
    "genre_name": genreName,
    "genre_image": genreImage,
  };
}
