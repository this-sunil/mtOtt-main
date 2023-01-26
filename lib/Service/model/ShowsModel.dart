// To parse this JSON data, do
//
//     final showsModel = showsModelFromJson(jsonString);

import 'dart:convert';

ShowsModel showsModelFromJson(String str) => ShowsModel.fromJson(json.decode(str));

String showsModelToJson(ShowsModel data) => json.encode(data.toJson());

class ShowsModel {
  ShowsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory ShowsModel.fromJson(Map<String, dynamic> json) => ShowsModel(
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
    required this.seriesName,
    required this.seriesDesc,
    required this.seriesPoster,
    required this.seriesCover,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.isFeatured,
    required this.isSlider,
    required this.status,
    required this.totalSeason,
    required this.seasonData,
  });

  String id;
  String seriesName;
  String seriesDesc;
  String seriesPoster;
  String seriesCover;
  String totalViews;
  String totalRate;
  String rateAvg;
  String isFeatured;
  String isSlider;
  String status;
  int totalSeason;
  List<SeasonDatum> seasonData;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    seriesName: json["series_name"],
    seriesDesc: json["series_desc"],
    seriesPoster: json["series_poster"],
    seriesCover: json["series_cover"],
    totalViews: json["total_views"],
    totalRate: json["total_rate"],
    rateAvg: json["rate_avg"],
    isFeatured: json["is_featured"],
    isSlider: json["is_slider"],
    status: json["status"],
    totalSeason: json["total_season"],
    seasonData: List<SeasonDatum>.from(json["season_data"].map((x) => SeasonDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "series_name": seriesName,
    "series_desc": seriesDesc,
    "series_poster": seriesPoster,
    "series_cover": seriesCover,
    "total_views": totalViews,
    "total_rate": totalRate,
    "rate_avg": rateAvg,
    "is_featured": isFeatured,
    "is_slider": isSlider,
    "status": status,
    "total_season": totalSeason,
    "season_data": List<dynamic>.from(seasonData.map((x) => x.toJson())),
  };
}

class SeasonDatum {
  SeasonDatum({
    required this.id,
    required this.seriesId,
    required this.seasonName,
    required this.status,
  });

  String id;
  String seriesId;
  String seasonName;
  String status;

  factory SeasonDatum.fromJson(Map<String, dynamic> json) => SeasonDatum(
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
