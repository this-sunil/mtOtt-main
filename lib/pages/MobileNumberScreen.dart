/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mtott/pages/VerificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
*/
/*Call Login Api*//*

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  TextEditingController mobileNumber=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey();
  loginApi(BuildContext context) async{

    print("Mobile Number ${mobileNumber.text}");
    SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await post(Uri.parse(login),body: {"phone":mobileNumber.text});
    */
/* print("Login+ ${resp.data}");*//*

    final result= jsonDecode(resp.body);

    if(resp.statusCode==200){
      if(result["status"]==true){
        print("Login +${resp.body}");
        pref.setString("userId", result["data"][0]["id"]);
        Navigator.push(context,PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => VerificationScreen(mobile: mobileNumber.text),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${result["message"]}")));
      }
    }
    else{
      print("Error in Api ${resp.request!.url}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar:  AppBar(
        elevation: 0,
       
        leading: IconButton(

            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("asset/logo/leftarrow.svg")),



      ),
      body:
      Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Continue with mobile number",style: GoogleFonts.inter(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:20,horizontal: 20),
              child: TextFormField(
                autofocus: true,
                controller: mobileNumber,
                cursorHeight: 35,
                maxLength: 10,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: "",

                  prefix:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("+91 |",style: GoogleFonts.inter(color: Colors.white60,fontSize: 16,fontWeight: FontWeight.w600)),
                  ),

                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 80,vertical: 20))
                  ),
                  onPressed: (){
                    loginApi(context);
                  }, child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("Continue",style: GoogleFonts.inter(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600)),
                  Icon(Icons.keyboard_arrow_right),

                ]),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("By clicking continue,you agree to our ",style: GoogleFonts.inter(color: Colors.white30,fontSize: 10,fontWeight: FontWeight.w600)),
                  Text("Terms of Use",style: GoogleFonts.inter(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("and acknowledge that you have read our ",style: GoogleFonts.inter(color: Colors.white30,fontSize: 10,fontWeight: FontWeight.w600)),
                  Text("Privacy Policy",style: GoogleFonts.inter(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
