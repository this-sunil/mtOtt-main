// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
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
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.type,
    required this.commentOn,
  });

  String id;
  String postId;
  String userId;
  String commentText;
  String type;
  DateTime commentOn;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    postId: json["post_id"],
    userId: json["user_id"],
    commentText: json["comment_text"],
    type: json["type"],
    commentOn: DateTime.parse(json["comment_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "user_id": userId,
    "comment_text": commentText,
    "type": type,
    "comment_on": commentOn.toIso8601String(),
  };
}
