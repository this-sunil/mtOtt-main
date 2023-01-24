// To parse this JSON data, do
//
//     final musicCategoryModel = musicCategoryModelFromJson(jsonString);

import 'dart:convert';

MusicCategoryModel musicCategoryModelFromJson(String str) => MusicCategoryModel.fromJson(json.decode(str));

String musicCategoryModelToJson(MusicCategoryModel data) => json.encode(data.toJson());

class MusicCategoryModel {
  MusicCategoryModel({
    required this.status,
    required this.musicResponse,
  });

  bool status;
  List<MusicResponse> musicResponse;

  factory MusicCategoryModel.fromJson(Map<String, dynamic> json) => MusicCategoryModel(
    status: json["status"],
    musicResponse: List<MusicResponse>.from(json["music_response"].map((x) => MusicResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "music_response": List<dynamic>.from(musicResponse.map((x) => x.toJson())),
  };
}

class MusicResponse {
  MusicResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.musicData,
  });

  String id;
  String name;
  String image;
  String status;
  List<MusicDatum> musicData;

  factory MusicResponse.fromJson(Map<String, dynamic> json) => MusicResponse(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    status: json["status"],
    musicData: List<MusicDatum>.from(json["music_data"].map((x) => MusicDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
    "music_data": List<dynamic>.from(musicData.map((x) => x.toJson())),
  };
}

class MusicDatum {
  MusicDatum({
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

  factory MusicDatum.fromJson(Map<String, dynamic> json) => MusicDatum(
    id: json["id"],
    musicType: json["music_type"],
    title: json["title"],
    singer: json["singer"],
    musicCover: json["music_cover"],
    music: json["music"],
    totalViews: json["total_views"],
    status: json["status"],
    deleted: json["deleted"],
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
