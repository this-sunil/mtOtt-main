import 'dart:io';

import 'package:mtott/const.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return bannerAdUnitIdIos;
    } else {
      throw  UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitialAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return interstitialAdUnitIdIos;
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardedAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return rewardedAdUnitIdIos;
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }
}