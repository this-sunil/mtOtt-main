import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/DashBoardScreen.dart';
import 'package:mtott/pages/SignInScreen.dart';
import 'package:mtott/pages/VerificationOtpScreen.dart';
import 'package:mtott/pages/VerificationScreen.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fname=TextEditingController();
  TextEditingController lname=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController mobile=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController cpass=TextEditingController();
  GlobalKey<FormState> signUpKey=GlobalKey<FormState>();
  bool flag1=false;
  bool flag2=false;
  bool flag=false;
  bool flags=false;
  @override
  void initState() {

    super.initState();
  }
  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    email.dispose();
    mobile.dispose();
    password.dispose();
    cpass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      resizeToAvoidBottomInset: true,
      body:CustomScrollView(
        
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(

            automaticallyImplyLeading: false,
            systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            expandedHeight: 350.0,
            backgroundColor: Colors.white,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            flexibleSpace:Stack(
              children: [
                Positioned.fill(
                  child: FlexibleSpaceBar(
                    background: Image.asset(
                      'asset/logo/logo.png',
                      fit: BoxFit.cover,
                    ),
                    stretchModes: const [
                      StretchMode.blurBackground,
                      StretchMode.zoomBackground,
                    ],
                  ),
                ),
                Positioned(
                    bottom: -7,
                    left: 0,right: 0,
                    child: Container(
                  height: 50.0,


                  decoration:   const BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),

                  ),

                )),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child:Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height-300,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Form(
                  key: signUpKey,
                  child: ListView(
                    padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sign Up",style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333945))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15,right: 10),
                                child:
                                Stack(
                                    children: [
                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(

                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.grey,width: .5),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                        child:
                                        TextFormField(
                                          controller: fname,
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(color: Colors.black),
                                          validator: (value) {

                                            if(value!.isEmpty){
                                              return "Please enter your first name";
                                            }
                                            return null;

                                          },
                                          autofocus: true,
                                          decoration:  InputDecoration(

                                            border: InputBorder.none,
                                            hintText: "first name",
                                            hintStyle: GoogleFonts.inter(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),

                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Stack(
                                    children: [

                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(

                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.grey,width: .5),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child:
                                        TextFormField(
                                          controller: lname,
                                          validator: (value) {

                                            if(value!.isEmpty){
                                              return "Please enter your last name";
                                            }
                                            return null;

                                          },
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(color: Colors.black),
                                          decoration:  InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "last name",

                                            hintStyle: GoogleFonts.inter(color: Colors.grey),
                                          ),
                                        ),
                                      ),




                                    ]),
                              ),

                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child:
                        Stack(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey,width: .5),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                child:
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: email,
                                  validator: (value) {

                                    if(value!.isEmpty){
                                      return "Please enter email address";
                                    }
                                    else  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;

                                  },
                                  decoration:  InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "email address",
                                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                                  ),
                                )
                              ),
                            ]),


                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child: Stack(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey,width: .5),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                  child:
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: mobile,
                                    validator: (value) {
                                      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = RegExp(patttern);
                                      if (value!.isEmpty) {
                                        return 'Please enter mobile number';
                                      }
                                      else if (!regExp.hasMatch(value)) {
                                        return 'Please enter valid mobile number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,


                                    maxLength: 10,
                                    decoration:  InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,

                                      hintText: "mobile no",
                                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  ),
                              ),
                            ]),


                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child:  Stack(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey,width: .5),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                  child:
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    obscureText: flag1,
                                    validator: (value){
                                      if (value!.isEmpty) {
                                        return "Please Re-Enter Password";
                                      } else if (value.length < 8) {
                                        return "Password must be at least 8 characters long";
                                      }
                                      else {
                                        return null;
                                      }
                                    },

                                    style: const TextStyle(color: Colors.black),
                                    controller: password,
                                    decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "password",
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.only(left: 30),
                                        icon: Icon(flag1
                                            ? Icons.visibility_off
                                            : Icons.visibility,color: Colors.black),
                                        onPressed: () {
                                          setState(
                                                () {
                                              flag1 = !flag1;
                                            },
                                          );
                                        },
                                      ),

                                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  ),
                              ),
                            ]),

                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child:  Stack(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey,width: .5),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                  child:
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    controller: cpass,

                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Re-Enter Confirm Password";
                                      } else if (value.length < 8) {
                                        return "Password must be atleast 8 characters long";
                                      } else if (value != password.text) {
                                        return "Password must be same as above";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                    obscureText: flag2,

                                    keyboardType: TextInputType.text,
                                    decoration:  InputDecoration(
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.only(left: 30),
                                        icon: Icon(flag2
                                            ? Icons.visibility_off
                                            : Icons.visibility,color: Colors.black),
                                        onPressed: () {
                                          setState(
                                                () {
                                              flag2 = !flag2;
                                            },
                                          );
                                        },
                                      ),
                                      border: InputBorder.none,
                                      hintText: "confirm password",
                                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  ),
                              ),
                            ]),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child: FloatingActionButton.extended(
                          heroTag: "Sign Up",
                            extendedPadding: const EdgeInsets.symmetric(horizontal: 200,vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onPressed: (){
                              if(signUpKey.currentState!.validate()){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtpScreen(firstname: fname.text, lastname: lname.text, email: email.text, phone: mobile.text, password: password.text, countryCode: "+91")));
                                signUpKey.currentState!.save();
                              }
                            }, label: Text("Sign Up",style: GoogleFonts.inter(color: Colors.white)),backgroundColor:Colors.deepPurpleAccent),
                      ),




                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?",style: TextStyle(color: Colors.black)),
                          TextButton(child:const Text("Sign In"),onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
