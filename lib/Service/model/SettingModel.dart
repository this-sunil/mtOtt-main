// To parse this JSON data, do
//
//     final settingsm = settingsmFromJson(jsonString);

import 'dart:convert';

SettingModel settingsmFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingsmToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  SettingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
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
    required this.envatoBuyerName,
    required this.envatoPurchaseCode,
    required this.envatoBuyerEmail,
    required this.envatoPurchasedStatus,
    required this.envatoIosPurchaseCode,
    required this.envatoIosPurchasedStatus,
    required this.packageName,
    required this.iosBundleIdentifier,
    required this.emailFrom,
    required this.onesignalAppId,
    required this.onesignalRestKey,
    required this.appName,
    required this.appLogo,
    required this.appEmail,
    required this.appVersion,
    required this.appAuthor,
    required this.appContact,
    required this.appWebsite,
    required this.appDescription,
    required this.appDevelopedBy,
    required this.appPrivacyPolicy,
    required this.apiLatestLimit,
    required this.apiPageLimit,
    required this.apiCatOrderBy,
    required this.apiCatPostOrderBy,
    required this.apiLanOrderBy,
    required this.apiGenOrderBy,
    required this.publisherId,
    required this.interstitalAd,
    required this.interstitalAdId,
    required this.interstitalAdClick,
    required this.bannerAd,
    required this.bannerAdId,
    required this.publisherIdIos,
    required this.appIdIos,
    required this.interstitalAdIos,
    required this.interstitalAdIdIos,
    required this.interstitalAdClickIos,
    required this.bannerAdIos,
    required this.bannerAdIdIos,
    required this.iosBannerAdType,
    required this.iosBannerFacebookId,
    required this.iosInterstitalAdType,
    required this.iosInterstitalFacebookId,
    required this.bannerAdType,
    required this.bannerFacebookId,
    required this.interstitalAdType,
    required this.interstitalFacebookId,
    required this.userAgent,
    required this.omdbApiKey,
  });

  String id;
  String envatoBuyerName;
  String envatoPurchaseCode;
  String envatoBuyerEmail;
  String envatoPurchasedStatus;
  String envatoIosPurchaseCode;
  String envatoIosPurchasedStatus;
  String packageName;
  String iosBundleIdentifier;
  String emailFrom;
  String onesignalAppId;
  String onesignalRestKey;
  String appName;
  String appLogo;
  String appEmail;
  String appVersion;
  String appAuthor;
  String appContact;
  String appWebsite;
  String appDescription;
  String appDevelopedBy;
  String appPrivacyPolicy;
  String apiLatestLimit;
  String apiPageLimit;
  String apiCatOrderBy;
  String apiCatPostOrderBy;
  String apiLanOrderBy;
  String apiGenOrderBy;
  String publisherId;
  String interstitalAd;
  String interstitalAdId;
  String interstitalAdClick;
  String bannerAd;
  String bannerAdId;
  String publisherIdIos;
  String appIdIos;
  String interstitalAdIos;
  String interstitalAdIdIos;
  String interstitalAdClickIos;
  String bannerAdIos;
  String bannerAdIdIos;
  String iosBannerAdType;
  String iosBannerFacebookId;
  String iosInterstitalAdType;
  String iosInterstitalFacebookId;
  String bannerAdType;
  String bannerFacebookId;
  String interstitalAdType;
  String interstitalFacebookId;
  String userAgent;
  String omdbApiKey;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    envatoBuyerName: json["envato_buyer_name"],
    envatoPurchaseCode: json["envato_purchase_code"],
    envatoBuyerEmail: json["envato_buyer_email"],
    envatoPurchasedStatus: json["envato_purchased_status"],
    envatoIosPurchaseCode: json["envato_ios_purchase_code"],
    envatoIosPurchasedStatus: json["envato_ios_purchased_status"],
    packageName: json["package_name"],
    iosBundleIdentifier: json["ios_bundle_identifier"],
    emailFrom: json["email_from"],
    onesignalAppId: json["onesignal_app_id"],
    onesignalRestKey: json["onesignal_rest_key"],
    appName: json["app_name"],
    appLogo: json["app_logo"],
    appEmail: json["app_email"],
    appVersion: json["app_version"],
    appAuthor: json["app_author"],
    appContact: json["app_contact"],
    appWebsite: json["app_website"],
    appDescription: json["app_description"],
    appDevelopedBy: json["app_developed_by"],
    appPrivacyPolicy: json["app_privacy_policy"],
    apiLatestLimit: json["api_latest_limit"],
    apiPageLimit: json["api_page_limit"],
    apiCatOrderBy: json["api_cat_order_by"],
    apiCatPostOrderBy: json["api_cat_post_order_by"],
    apiLanOrderBy: json["api_lan_order_by"],
    apiGenOrderBy: json["api_gen_order_by"],
    publisherId: json["publisher_id"],
    interstitalAd: json["interstital_ad"],
    interstitalAdId: json["interstital_ad_id"],
    interstitalAdClick: json["interstital_ad_click"],
    bannerAd: json["banner_ad"],
    bannerAdId: json["banner_ad_id"],
    publisherIdIos: json["publisher_id_ios"],
    appIdIos: json["app_id_ios"],
    interstitalAdIos: json["interstital_ad_ios"],
    interstitalAdIdIos: json["interstital_ad_id_ios"],
    interstitalAdClickIos: json["interstital_ad_click_ios"],
    bannerAdIos: json["banner_ad_ios"],
    bannerAdIdIos: json["banner_ad_id_ios"],
    iosBannerAdType: json["ios_banner_ad_type"],
    iosBannerFacebookId: json["ios_banner_facebook_id"],
    iosInterstitalAdType: json["ios_interstital_ad_type"],
    iosInterstitalFacebookId: json["ios_interstital_facebook_id"],
    bannerAdType: json["banner_ad_type"],
    bannerFacebookId: json["banner_facebook_id"],
    interstitalAdType: json["interstital_ad_type"],
    interstitalFacebookId: json["interstital_facebook_id"],
    userAgent: json["user_agent"],
    omdbApiKey: json["omdb_api_key"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "envato_buyer_name": envatoBuyerName,
    "envato_purchase_code": envatoPurchaseCode,
    "envato_buyer_email": envatoBuyerEmail,
    "envato_purchased_status": envatoPurchasedStatus,
    "envato_ios_purchase_code": envatoIosPurchaseCode,
    "envato_ios_purchased_status": envatoIosPurchasedStatus,
    "package_name": packageName,
    "ios_bundle_identifier": iosBundleIdentifier,
    "email_from": emailFrom,
    "onesignal_app_id": onesignalAppId,
    "onesignal_rest_key": onesignalRestKey,
    "app_name": appName,
    "app_logo": appLogo,
    "app_email": appEmail,
    "app_version": appVersion,
    "app_author": appAuthor,
    "app_contact": appContact,
    "app_website": appWebsite,
    "app_description": appDescription,
    "app_developed_by": appDevelopedBy,
    "app_privacy_policy": appPrivacyPolicy,
    "api_latest_limit": apiLatestLimit,
    "api_page_limit": apiPageLimit,
    "api_cat_order_by": apiCatOrderBy,
    "api_cat_post_order_by": apiCatPostOrderBy,
    "api_lan_order_by": apiLanOrderBy,
    "api_gen_order_by": apiGenOrderBy,
    "publisher_id": publisherId,
    "interstital_ad": interstitalAd,
    "interstital_ad_id": interstitalAdId,
    "interstital_ad_click": interstitalAdClick,
    "banner_ad": bannerAd,
    "banner_ad_id": bannerAdId,
    "publisher_id_ios": publisherIdIos,
    "app_id_ios": appIdIos,
    "interstital_ad_ios": interstitalAdIos,
    "interstital_ad_id_ios": interstitalAdIdIos,
    "interstital_ad_click_ios": interstitalAdClickIos,
    "banner_ad_ios": bannerAdIos,
    "banner_ad_id_ios": bannerAdIdIos,
    "ios_banner_ad_type": iosBannerAdType,
    "ios_banner_facebook_id": iosBannerFacebookId,
    "ios_interstital_ad_type": iosInterstitalAdType,
    "ios_interstital_facebook_id": iosInterstitalFacebookId,
    "banner_ad_type": bannerAdType,
    "banner_facebook_id": bannerFacebookId,
    "interstital_ad_type": interstitalAdType,
    "interstital_facebook_id": interstitalFacebookId,
    "user_agent": userAgent,
    "omdb_api_key": omdbApiKey,
  };
}

