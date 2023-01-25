import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'MyApp.dart';

late String data;

List<String> recentSearch=[];
bool flag=false;
bool planBuy=false;
HashSet<String> views=HashSet();
enum InternetState{internetInitial,internetSuccess,internetFailure}
HashSet<String> selectFav=HashSet<String>();
const bool debug=true;
void main() async{
   WidgetsFlutterBinding.ensureInitialized();

   await FlutterDownloader.initialize(

       debug: debug, // optional: set to false to disable printing logs to console (default: true)
       ignoreSsl: true,
   );
   await JustAudioBackground.init(
     androidNotificationChannelId: 'com.ryanheise.audioservice',
     androidNotificationChannelName: 'mediaPlayback',
     androidNotificationOngoing: true,
   );

   Firebase.initializeApp().then((value){
     print("Firebase Connected");
   });
   SharedPreferences pref=await SharedPreferences.getInstance();

   data=pref.getString("uid").toString();
   MobileAds.instance.initialize();
   runApp(const MyApp());
}




