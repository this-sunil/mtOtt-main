import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../const.dart';
import '../plan/PlanScreen.dart';
import 'DashBoardScreen.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String password;
  final String countryCode;
  const VerifyOtpScreen({super.key, required this.firstname,required this.lastname,required this.email,required this.phone,required this.password,required this.countryCode});
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}
class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late String verificationCode;
  int start = 30;
  bool wait = false;

  TextEditingController otpNo = TextEditingController();
  final firstDigit = TextEditingController();
  final secondDigit = TextEditingController();
  final thirdDigit = TextEditingController();
  final fourthDigit = TextEditingController();
  final fifthDigit = TextEditingController();
  final sixthDigit = TextEditingController();
  int second=30;
  Timer timer = Timer(Duration.zero, () {});
  void startTimer() {

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second>0) {
        second--;
      } else {
        timer.cancel();
      }
    });
    setState(() {

    });

  }
  signUp() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    final resp=await post(Uri.parse(register),body: {"name":"${widget.firstname} ${widget.lastname}","email":widget.email,"phone":widget.phone,"password":widget.password});

    debugPrint("Response register ${resp.body}");
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      /*QuickAlert.show(context: context, type: QuickAlertType.success,title: result["message"]);*/
      debugPrint("Response register ${resp.body}");
      if(result["status"]){
        pref.setString("uid", result["data"][0]["id"]);
        pref.setString("fullName", result["data"][0]["name"]);
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
    }
    else{
      debugPrint("Error in Api ${resp.request!.url} and ${resp.body}");
    }

  }

  @override
  void initState() {
    print("main number from otp ${widget.phone}");
    verificationCode = "";
    firstDigit.selection= TextSelection.fromPosition(TextPosition(offset: firstDigit.text.length));
    secondDigit.selection= TextSelection.fromPosition(TextPosition(offset: secondDigit.text.length));
    thirdDigit.selection= TextSelection.fromPosition(TextPosition(offset: thirdDigit.text.length));
    fourthDigit.selection= TextSelection.fromPosition(TextPosition(offset: fourthDigit.text.length));
    fifthDigit.selection= TextSelection.fromPosition(TextPosition(offset: fifthDigit.text.length));
    sixthDigit.selection= TextSelection.fromPosition(TextPosition(offset: sixthDigit.text.length));
    verifyNumber(context);
    super.initState();
  }
  @override
  void dispose() {
    firstDigit.dispose();
    secondDigit.dispose();
    thirdDigit.dispose();
    fourthDigit.dispose();
    fifthDigit.dispose();
    sixthDigit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(second==0){
      wait=false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(
                    height: 18,
                  ),


                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,

                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'asset/logo/logo.png',

                          ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Enter your OTP code number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _textFieldOTP(
                                first: true, last: false, otp: firstDigit),
                            const SizedBox(width: 2),
                            _textFieldOTP(
                                first: false, last: false, otp: secondDigit),
                            const SizedBox(width: 2),
                            _textFieldOTP(
                                first: false, last: false, otp: thirdDigit),
                            const SizedBox(width: 2),
                            _textFieldOTP(
                                first: false, last: false, otp: fourthDigit),
                            const SizedBox(width: 2),
                            _textFieldOTP(first: false, last: false,otp:fifthDigit),
                            const SizedBox(width: 2),
                            _textFieldOTP(first: false, last: true,otp: sixthDigit),
                          ],
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              print("verificationCode $verificationCode");
                              /*SharedPreferences pref=await SharedPreferences.getInstance();
                              pref.setString("key", widget.userID);*/

                              if(verificationCode.isNotEmpty) {
                                if(firstDigit.text.isNotEmpty || secondDigit.text.isNotEmpty || thirdDigit.text.isNotEmpty || fourthDigit.text.isNotEmpty || fifthDigit.text.isNotEmpty || sixthDigit.text.isNotEmpty){
                                  await FirebaseAuth.instance
                                      .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationCode,
                                          smsCode: firstDigit.text+secondDigit.text+thirdDigit.text+fourthDigit.text+fifthDigit.text+sixthDigit.text)).then((value) {
                                    if (value != null) {
                                      signUp();
                                    }
                                  });

                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter valid otp number")));
                                }

                              }



                            },
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  wait==true?Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Resend Code 00:$second",style: GoogleFonts.inter(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ):Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't Receive code?",style:GoogleFonts.inter(fontSize: 15,color: const Color(0xFF333945))),
                        TextButton(onPressed: (){

                          verifyNumber(context);

                        }, child: Text("Resend Again",style: GoogleFonts.inter(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
  var data;
  verifyNumber(context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    SmsAutoFill().listenForCode;
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.countryCode + widget.phone,

        timeout: const Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async {
          var appSignatureId = await SmsAutoFill().getAppSignature;
          Map sendOtp = {
            "mobile_number": widget.countryCode + widget.phone,
            "app_signature_id": appSignatureId,
          };

          /*SmsAutoFill().getAppSignature.then((signature) {
              print(signature);
            });*/
          data=credential.smsCode!.toString();


          setState(() {
            firstDigit.text = credential.smsCode!.substring(0, 1);
            secondDigit.text = credential.smsCode!.substring(1, 2);
            thirdDigit.text = credential.smsCode!.substring(2, 3);
            fourthDigit.text = credential.smsCode!.substring(3, 4);
            fifthDigit.text = credential.smsCode!.substring(4, 5);
            sixthDigit.text = credential.smsCode!.substring(5, 6);
            otpNo.text = firstDigit.text + secondDigit.text + thirdDigit.text +
                fourthDigit.text + fifthDigit.text + sixthDigit.text;
          });




          print(sendOtp);
        },
        verificationFailed: (FirebaseAuthException e) async {

          //Fluttertoast.showToast(msg: "Please try again later");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please try again later")));
        },

        codeSent: (String verificationId, int? resendeingToken) {


          verificationCode = verificationId;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification Code sent on your phone number")));
          startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) async {

          verificationCode = verificationId;


        });
  }

  Widget _textFieldOTP({required bool first, last,required TextEditingController otp}) {
    return Flexible(

      flex: 4,

      child: TextField(
        controller: otp,
        autofocus: true,
        onChanged: (value) {
          if (value.isNotEmpty || first == true) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty || last == true) {
            FocusScope.of(context).previousFocus();
          }
          print(otp);
        },
        showCursor: true,
        readOnly: false,

        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,


        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

}
