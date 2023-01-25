// To parse this JSON data, do
//
//     final watchListModel = watchListModelFromJson(jsonString);

import 'dart:convert';

WatchListModel watchListModelFromJson(String str) => WatchListModel.fromJson(json.decode(str));

String watchListModelToJson(WatchListModel data) => json.encode(data.toJson());

class WatchListModel {
  WatchListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory WatchListModel.fromJson(Map<String, dynamic> json) => WatchListModel(
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
    required this.languageId,
    required this.genreId,
    required this.movieType,
    required this.movieTitle,
    required this.movieCover,
    required this.moviePoster,
    required this.movieUrl,
    required this.videoId,
    required this.movieDesc,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.isFeatured,
    required this.isSlider,
    required this.subtitle,
    required this.isQuality,
    required this.status,
    required this.director,
    required this.price,
    required this.isTopPick,
    required this.seriesName,
    required this.seriesDesc,
    required this.seriesPoster,
    required this.seriesCover,
    required this.watchid,
  });

  String id;
  String languageId;
  String genreId;
  String movieType;
  String movieTitle;
  String movieCover;
  String moviePoster;
  String movieUrl;
  String videoId;
  String movieDesc;
  String totalViews;
  String totalRate;
  String rateAvg;
  String isFeatured;
  String isSlider;
  String subtitle;
  String isQuality;
  String status;
  String director;
  String price;

  String isTopPick;
  String seriesName;
  String seriesDesc;
  String seriesPoster;
  String seriesCover;
  String watchid;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"]??'',
    languageId: json["language_id"]??'',
    genreId: json["genre_id"]??'',
    movieType: json["movie_type"]??'',
    movieTitle: json["movie_title"]??"",
    movieCover: json["movie_cover"]??"",
    moviePoster: json["movie_poster"]??"",
    movieUrl: json["movie_url"]??"",
    videoId: json["video_id"]??'',
    movieDesc: json["movie_desc"]??"",
    totalViews: json["total_views"]??"",
    totalRate: json["total_rate"]??"",
    rateAvg: json["rate_avg"]??"",
    isFeatured: json["is_featured"]??"",
    isSlider: json["is_slider"]??"",
    subtitle: json["subtitle"]??"",
    isQuality: json["is_quality"]??"",
    status: json["status"]??"",
    director: json["director"]??"",
    price: json["price"]??"",
    isTopPick: json["is_top_pick"]??"",
    seriesName: json["series_name"]??"",
    seriesDesc: json["series_desc"]??"",
    seriesPoster: json["series_poster"]??"",
    seriesCover: json["series_cover"]??"",
    watchid: json["watchid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_id": languageId,
    "genre_id": genreId,
    "movie_type": movieType,
    "movie_title": movieTitle,
    "movie_cover": movieCover,
    "movie_poster": moviePoster,
    "movie_url": movieUrl,
    "video_id": videoId,
    "movie_desc": movieDesc,
    "total_views": totalViews,
    "total_rate": totalRate,
    "rate_avg": rateAvg,
    "is_featured": isFeatured,
    "is_slider": isSlider,
    "subtitle": subtitle,
    "is_quality": isQuality,
    "status": status,
    "director": director,
    "price": price,
    "is_top_pick": isTopPick,
    "series_name": seriesName,
    "series_desc": seriesDesc,
    "series_poster": seriesPoster,
    "series_cover": seriesCover,
    "watchid": watchid,
  };
}
