// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    required this.status,
    required this.searchResponse,
  });

  bool status;
  SearchResponse searchResponse;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json["status"],
    searchResponse: SearchResponse.fromJson(json["search_response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "search_response": searchResponse.toJson(),
  };
}

class SearchResponse {
  SearchResponse({
    required this.movies,
    required this.songs,
    required this.series,
    required this.channels,
  });

  List<Movie> movies;
  List<Song> songs;
  List<Series> series;
  List<Channel> channels;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    movies: List<Movie>.from(json["movies"].map((x) => Movie.fromJson(x))),
    songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
    series: List<Series>.from(json["series"].map((x) => Series.fromJson(x))),
    channels: List<Channel>.from(json["channels"].map((x) => Channel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
    "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
    "series": List<dynamic>.from(series.map((x) => x.toJson())),
    "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
  };
}

class Channel {
  Channel({
    required this.id,
    required this.catId,
    required this.channelType,
    required this.channelTitle,
    required this.channelUrl,
    required this.channelTypeIos,
    required this.channelUrlIos,
    required this.channelPoster,
    required this.channelThumbnail,
    required this.channelDesc,
    required this.featuredChannel,
    required this.sliderChannel,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.status,
    required this.userAgent,
    required this.userAgentType,
    required this.userAgentName,
  });

  String id;
  String catId;
  String channelType;
  String channelTitle;
  String channelUrl;
  String channelTypeIos;
  String channelUrlIos;
  String channelPoster;
  String channelThumbnail;
  String channelDesc;
  String featuredChannel;
  String sliderChannel;
  String totalViews;
  String totalRate;
  String rateAvg;
  String status;
  String userAgent;
  String userAgentType;
  String userAgentName;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json["id"],
    catId: json["cat_id"],
    channelType: json["channel_type"],
    channelTitle: json["channel_title"],
    channelUrl: json["channel_url"],
    channelTypeIos: json["channel_type_ios"],
    channelUrlIos: json["channel_url_ios"],
    channelPoster: json["channel_poster"],
    channelThumbnail: json["channel_thumbnail"],
    channelDesc: json["channel_desc"],
    featuredChannel: json["featured_channel"],
    sliderChannel: json["slider_channel"],
    totalViews: json["total_views"],
    totalRate: json["total_rate"],
    rateAvg: json["rate_avg"],
    status: json["status"],
    userAgent: json["user_agent"],
    userAgentType: json["user_agent_type"],
    userAgentName: json["user_agent_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cat_id": catId,
    "channel_type": channelType,
    "channel_title": channelTitle,
    "channel_url": channelUrl,
    "channel_type_ios": channelTypeIos,
    "channel_url_ios": channelUrlIos,
    "channel_poster": channelPoster,
    "channel_thumbnail": channelThumbnail,
    "channel_desc": channelDesc,
    "featured_channel": featuredChannel,
    "slider_channel": sliderChannel,
    "total_views": totalViews,
    "total_rate": totalRate,
    "rate_avg": rateAvg,
    "status": status,
    "user_agent": userAgent,
    "user_agent_type": userAgentType,
    "user_agent_name": userAgentName,
  };
}

class Movie {
  Movie({
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
    required this.date,
    required this.isTopPick,
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
  DateTime date;
  String isTopPick;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json["id"],
    languageId: json["language_id"],
    genreId: json["genre_id"],
    movieType: json["movie_type"],
    movieTitle: json["movie_title"],
    movieCover: json["movie_cover"],
    moviePoster: json["movie_poster"],
    movieUrl: json["movie_url"],
    videoId: json["video_id"],
    movieDesc: json["movie_desc"],
    totalViews: json["total_views"],
    totalRate: json["total_rate"],
    rateAvg: json["rate_avg"],
    isFeatured: json["is_featured"],
    isSlider: json["is_slider"],
    subtitle: json["subtitle"],
    isQuality: json["is_quality"],
    status: json["status"],
    director: json["director"],
    price: json["price"],
    date: DateTime.parse(json["date"]),
    isTopPick: json["is_top_pick"],
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
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "is_top_pick": isTopPick,
  };
}

class Series {
  Series({
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

  factory Series.fromJson(Map<String, dynamic> json) => Series(
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

class Song {
  Song({
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

  factory Song.fromJson(Map<String, dynamic> json) => Song(
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
