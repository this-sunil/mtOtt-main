import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mtott/pages/SplashScreen.dart';
import 'package:mtott/utility/theme/ThemeCubit.dart';
import 'const.dart';
import 'package:flutter/material.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
  @override
  void initState() {

    _initGoogleMobileAds();
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