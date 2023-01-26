import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
   Firebase.initializeApp().then((value){
     debugPrint("Firebase Connected");
   });
   SharedPreferences pref=await SharedPreferences.getInstance();
   data=pref.getString("uid").toString();
   runApp(const MyApp());
}




