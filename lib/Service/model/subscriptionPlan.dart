// To parse this JSON data, do
//
//     final subscriptionPlan = subscriptionPlanFromJson(jsonString);


import 'dart:convert';

SubscriptionPlan subscriptionPlanFromJson(String str) => SubscriptionPlan.fromJson(json.decode(str));

String subscriptionPlanToJson(SubscriptionPlan data) => json.encode(data.toJson());

class SubscriptionPlan {
  SubscriptionPlan({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
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
    required this.plan,
    required this.validity,
    required this.description,
    required this.price,
    required this.color,
    required this.status,
    required this.deleted,
  });

  String id;
  String plan;
  String validity;
  String description;
  String price;
  String color;
  String status;
  String deleted;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    plan: json["plan"],
    validity: json["validity"],
    description: json["description"],
    price: json["price"],
    color: json["color"],
    status: json["status"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan": plan,
    "validity": validity,
    "description": description,
    "price": price,
    "color": color,
    "status": status,
    "deleted": deleted,
  };
}
