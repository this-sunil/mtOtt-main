// To parse this JSON data, do
//
//     final latestChannelModel = latestChannelModelFromJson(jsonString);

import 'dart:convert';

LatestChannelModel latestChannelModelFromJson(String str) => LatestChannelModel.fromJson(json.decode(str));

String latestChannelModelToJson(LatestChannelModel data) => json.encode(data.toJson());

class LatestChannelModel {
  LatestChannelModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory LatestChannelModel.fromJson(Map<String, dynamic> json) => LatestChannelModel(
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
    required this.cid,
    required this.categoryName,
    required this.categoryImage,
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
  String cid;
  String categoryName;
  String categoryImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    cid: json["cid"],
    categoryName: json["category_name"],
    categoryImage: json["category_image"],
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
    "cid": cid,
    "category_name": categoryName,
    "category_image": categoryImage,
  };
}
