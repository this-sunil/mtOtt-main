import 'package:flutter/material.dart';
import '../main.dart';
import 'DashBoardScreen.dart';
import 'SignInScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;
  fetchData(){
    controller=AnimationController(vsync: this,duration: const Duration(seconds: 1));
    animation=Tween<double>(begin: 50,end: 200).animate(controller)..addListener(() { });
    controller.forward();
    setState(() {
      if(data=="null"){
        print("Token of sharedPreferences $data");
      }
      else{
        print("Coming started data with main $data");
      }
    });
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TweenAnimationBuilder(
          tween: Tween(begin: const Duration(seconds: 5),end: Duration.zero),
          onEnd: () {
            //print("End Of the screen");

            if(data!="null"){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoardScreen(title: 'MT OTT')));
            }
            else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
            }
          },
          builder: (context,value,child){
            return Container(
                decoration:const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/logo/logo.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.deepOrangeAccent, BlendMode.colorDodge),
                  ),
                ),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.asset("asset/logo/logo.png",width: animation.value.toDouble(),height: animation.value.toDouble()),
                  ),
                )
            );
          }, duration: const Duration(seconds: 3),
        ),
    );
  }
}
