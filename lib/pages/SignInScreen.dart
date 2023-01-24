import 'dart:convert';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:mtott/pages/SignUpPage.dart';
import 'package:mtott/plan/PlanScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import 'DashBoardScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController phone = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  GlobalKey<FormState> signInKey = GlobalKey<FormState>();
  String flag="";
  loginApi(BuildContext context) async{

    print("phone Number ${phone.text}");
    SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await post(Uri.parse(login),body: {"user_input":phone.text});
    debugPrint("Response register ${resp.body}");
    /* print("Login+ ${resp.data}");*/
    final result= jsonDecode(resp.body);

    if(resp.statusCode==200){
      if(result["status"]){
        print("Login +${resp.body} ${result["data"]["name"]}");
        pref.setString("uid", result["data"]["id"]);
        pref.setString("fullName", result["data"]["name"]);
        Navigator.push(context,PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => DashBoardScreen(title: appName),
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
    super.initState();
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }
  signUp(String email) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await post(Uri.parse(socialSignIn),body: {"email":email});
    debugPrint("Response register ${resp.body}");
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      debugPrint("Social Sign In Google and Facebook ${resp.body}");
      if(result["status"]){
        pref.setString("uid", result["data"]["id"]);
        pref.setString("fullName", result["data"]["name"]);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoardScreen(title: appName)));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text(result["message"])));
      }
    }
    else{
      debugPrint("Error in Api ${resp.request!.url} and ${resp.body}");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
            expandedHeight: 400.0,
            backgroundColor: Colors.white,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            floating: true,
            flexibleSpace: Stack(
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
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height - 300,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: signInKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Sign In",
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333945))),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: Colors.black),
                                  controller: phone,
                                  validator: (val) {
                                    if(val!.isEmpty){

                                      return "Please enter email address or phone";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(






                                   border: InputBorder.none,

                                    hintText: "email address or phone",
                                    hintStyle:
                                    GoogleFonts.inter(color: Colors.grey),
                                  ),
                                ),
                              ),



                        ]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: FloatingActionButton.extended(
                            heroTag: "Sign In",
                            extendedPadding: const EdgeInsets.symmetric(
                                horizontal: 200, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              if (signInKey.currentState!.validate()) {
                                loginApi(context);
                                signInKey.currentState!.save();
                              }
                            },
                            label: Text("Sign In",
                                style: GoogleFonts.inter(color: Colors.white)),
                            backgroundColor: Colors.deepPurpleAccent),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyle(color: Colors.black)),
                          TextButton(
                              child: Text("Sign Up"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              }),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: FloatingActionButton.extended(
                            heroTag: "Google",
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            extendedPadding: const EdgeInsets.symmetric(
                                horizontal: 200, vertical: 20),
                            onPressed: () async {
                              SharedPreferences pref=await SharedPreferences.getInstance();
                               GoogleSignInAccount? googleSignInAccount =
                                  await googleSignIn.signIn();

                                if (googleSignInAccount != null) {
                                  final GoogleSignInAuthentication
                                  googleSignInAuthentication =
                                  await googleSignInAccount.authentication;

                                  final AuthCredential credential =
                                  GoogleAuthProvider.credential(
                                    accessToken:
                                    googleSignInAuthentication.accessToken,
                                    idToken: googleSignInAuthentication.idToken,
                                  );
                                  try {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential).then((
                                      value) {
                                    setState(() {
                                      pref.setString("imageUrl",
                                          googleSignInAccount.photoUrl
                                              .toString());
                                      debugPrint(
                                          value.additionalUserInfo!.profile
                                              .toString());
                                      signUp(googleSignInAccount.email);
                                    });
                                  });
                                }on FirebaseAuthException catch  (e){
                                    pref.remove("imageUrl");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.black,
                                            content: Text(e.message.toString(),style: const TextStyle(color: Colors.white))));
                              }}

                            },
                            label: Row(
                              children: [
                                Icon(FontAwesomeIcons.google,
                                    color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Google",style: GoogleFonts.inter(color: Colors.white)),
                                ),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: FloatingActionButton.extended(
                            heroTag: "Facebook",
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {

                              final result = await facebookAuth.login(
                                  permissions: ['public_profile', 'email']);
                              final OAuthCredential facebookAuthCredential =
                                  FacebookAuthProvider.credential(
                                      result.accessToken!.token);
                              try {
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                    facebookAuthCredential)
                                    .then((value) {
                                  debugPrint("Facebook Email ${value
                                      .additionalUserInfo!.profile!["email"]}");
                                  signUp(value.additionalUserInfo!
                                      .profile!["email"]);
                                });
                              }on FirebaseAuthException catch  (e){
                                ScaffoldMessenger.of(context).showSnackBar(

                                    SnackBar(
                                        backgroundColor: Colors.black,
                                        content: Text(e.message.toString(),style: TextStyle(color: Colors.white))));
                              }
                            },
                            extendedPadding: EdgeInsets.symmetric(
                                horizontal: 200, vertical: 20),
                            label: Row(
                              children: [
                                Icon(FontAwesomeIcons.facebook,
                                    color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Facebook",style: GoogleFonts.inter(color: Colors.white)),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
