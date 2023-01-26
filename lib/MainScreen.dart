import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mtott/pages/SplashScreen.dart';
import 'package:mtott/utility/theme/ThemeCubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'const.dart';
import 'package:flutter/material.dart';

import 'main.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
init() async{
  await FlutterDownloader.initialize(

    debug: debug, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.audioservice',
    androidNotificationChannelName: 'mediaPlayback',
    androidNotificationOngoing: true,
  );
}
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
  checkPlanBy() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String uid=pref.getString("uid").toString();
    final resp=await post(Uri.parse(checkPlanBuyApi),body: {
      "user_id":uid,
    });
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      setState(() {
        planBuy=result["status"];
      });
      debugPrint("Response in Plan Check Or not Buy Api ${resp.request!.url} and \n ${resp.body}");
    }
    else{
      debugPrint("Error in Api ${resp.request!.url} and ${resp.statusCode}");
    }
  }
  @override
  void initState() {
    init();
    _initGoogleMobileAds();
    checkPlanBy();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeData>(builder: (context,state){
      return  MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme:state,
        home:const SplashScreen(),
      );
    });
  }
}