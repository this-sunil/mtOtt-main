
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/NewUserScreen.dart';


import 'DashBoardScreen.dart';
class FacebookScreen extends StatefulWidget {
  const FacebookScreen({Key? key}) : super(key: key);

  @override
  State<FacebookScreen> createState() => _FacebookScreenState();
}

class _FacebookScreenState extends State<FacebookScreen> {
  TextEditingController email=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  final FacebookAuth facebookAuth=FacebookAuth.instance;




/*Future<UserCredential> signIn(BuildContext context) async {


    final result = await facebookAuth.login(permissions: ['public_profile','email']);
    final OAuthCredential facebookAuthCredential =FacebookAuthProvider.credential(result.accessToken!.token);
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
   
  }*/
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
      backgroundColor:  Color(0xFF1B1F20),
      appBar:  AppBar(
        elevation: 0,
       
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("asset/logo/leftarrow.svg")),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Have a Facebook/Email account?",style: GoogleFonts.inter(color: Colors.white,fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0),
              child: TextFormField(
                autofocus: true,
                controller: email,
                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  hintText: "Email Address",
                 focusColor: Colors.blue,
                  hintStyle: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding:MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 60,vertical: 12))
                  ),
                  onPressed: (){
                    Navigator.push(context,PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) => const NewUserScreen(),
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
                  }, child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue",style: GoogleFonts.inter(color: Colors.white)),
                    Icon(Icons.keyboard_arrow_right,color: Colors.white),
                  ],
                ),
              )),
            ),
            Text("Or",style: GoogleFonts.inter(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
              child: ElevatedButton(onPressed: () async{
                final result = await facebookAuth.login(permissions: ['public_profile','email']);
                final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
                await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoardScreen(title: appName))));
              }, child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.facebook_sharp,color: Colors.white),
                    Text("Logged in via Facebook earlier?",style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
