class Music {
  Music({

    required this.image,
    required this.title,
    required this.url,
    required this.subtitle,
    required this.index,
  });

  String index;
  String image;
  String title;
   String url;
   String subtitle;

  factory Music.fromJson(Map<String, dynamic> json) => Music(
    index: json["index"],
    image: json["image"],
    title: json["name"],
    url: json["url"],
    subtitle:json["subtitle"],
  );

  Map<String, dynamic> toJson() => {
    "index":index,
    "image": image,
    "name": title,
    "url":url,
    "subtitle":subtitle,
  };
}