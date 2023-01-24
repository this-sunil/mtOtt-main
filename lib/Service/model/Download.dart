class Download {
  Download({

    required this.image,
    required this.title,
    required this.url,
    required this.description,
    required this.seriesId,
    required this.seasonId,
    required this.index,
  });

  String index;
  String image;
  String title;
  String url;
  String seasonId;
  String seriesId;
  String description;

  factory Download.fromJson(Map<String, dynamic> json) => Download(
    index: json["index"],
    image: json["image"],
    title: json["name"],
    url: json["url"],
    seasonId: json["seasonId"],
    seriesId: json["seriesId"],
    description:json["description"],
  );

  Map<String, dynamic> toJson() => {
    "index":index,
    "image": image,
    "name": title,
    "url":url,
    "description":description,
    "seasonId":seasonId,
    "seriesId":seasonId,
  };
}