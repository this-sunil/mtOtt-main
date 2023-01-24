// To parse this JSON data, do
//
//     final seasonModel = seasonModelFromJson(jsonString);

import 'dart:convert';

SeasonModel seasonModelFromJson(String str) => SeasonModel.fromJson(json.decode(str));

String seasonModelToJson(SeasonModel data) => json.encode(data.toJson());

class SeasonModel {
  SeasonModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
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
    required this.seasonId,
    required this.episodeTitle,
    required this.episodeType,
    required this.episodeUrl,
    required this.videoId,
    required this.episodePoster,
    required this.totalViews,
    required this.subtitle,
    required this.isQuality,
    required this.status,
  });

  String id;
  String seriesId;
  String seasonId;
  String episodeTitle;
  String episodeType;
  String episodeUrl;
  String videoId;
  String episodePoster;
  String totalViews;
  String subtitle;
  String isQuality;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    seriesId: json["series_id"],
    seasonId: json["season_id"],
    episodeTitle: json["episode_title"],
    episodeType: json["episode_type"],
    episodeUrl: json["episode_url"],
    videoId: json["video_id"],
    episodePoster: json["episode_poster"],
    totalViews: json["total_views"],
    subtitle: json["subtitle"],
    isQuality: json["is_quality"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "series_id": seriesId,
    "season_id": seasonId,
    "episode_title": episodeTitle,
    "episode_type": episodeType,
    "episode_url": episodeUrl,
    "video_id": videoId,
    "episode_poster": episodePoster,
    "total_views": totalViews,
    "subtitle": subtitle,
    "is_quality": isQuality,
    "status": status,
  };
}
