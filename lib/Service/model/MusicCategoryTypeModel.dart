// To parse this JSON data, do
//
//     final musicCategoryTypeModel = musicCategoryTypeModelFromJson(jsonString);

import 'dart:convert';

MusicCategoryTypeModel musicCategoryTypeModelFromJson(String str) => MusicCategoryTypeModel.fromJson(json.decode(str));

String musicCategoryTypeModelToJson(MusicCategoryTypeModel data) => json.encode(data.toJson());

class MusicCategoryTypeModel {
  MusicCategoryTypeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory MusicCategoryTypeModel.fromJson(Map<String, dynamic> json) => MusicCategoryTypeModel(
    status: json["status"],
    message: json["message"],
    data: json["data"]==null?[]:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
    required this.musicType,
    required this.title,
    required this.singer,
    required this.musicCover,
    required this.music,
    required this.totalViews,
    required this.status,
    required this.deleted,
  });

  String id;
  String musicType;
  String title;
  String singer;
  String musicCover;
  String music;
  String totalViews;
  String status;
  String deleted;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    musicType: json["music_type"]??"",
    title: json["title"]??"",
    singer: json["singer"]??"",
    musicCover: json["music_cover"]??"",
    music: json["music"]??"",
    totalViews: json["total_views"]??"",
    status: json["status"]??"",
    deleted: json["deleted"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "music_type": musicType,
    "title": title,
    "singer": singer,
    "music_cover": musicCover,
    "music": music,
    "total_views": totalViews,
    "status": status,
    "deleted": deleted,
  };
}
