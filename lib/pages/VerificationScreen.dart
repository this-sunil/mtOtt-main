import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/pages/DashBoardScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';
/*Mobile Number Authentication With Firebase*/
class VerificationScreen extends StatefulWidget {
  final String mobile;
  const VerificationScreen({Key? key,required this.mobile}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController first=TextEditingController();
  TextEditingController second=TextEditingController();
  TextEditingController third=TextEditingController();
  TextEditingController fourth=TextEditingController();
  TextEditingController fifth=TextEditingController();
  TextEditingController sixth=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  String verificationCode="";

  verifyNumber(context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    SmsAutoFill().listenForCode;
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobile}",
        timeout: const Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async {
          var appSignatureId = await SmsAutoFill().getAppSignature;
          Map sendOtp = {
            "mobile_number":"+91${widget.mobile}",
            "app_signature_id": appSignatureId,
          };
          /*SmsAutoFill().getAppSignature.then((signature) {
              print(signature);
            });*/
         /* data=credential.smsCode!.toString();*/
          setState(() {
            first.text = credential.smsCode!.substring(0, 1);
            second.text = credential.smsCode!.substring(1, 2);
            third.text = credential.smsCode!.substring(2, 3);
            fourth.text = credential.smsCode!.substring(3, 4);
            fifth.text = credential.smsCode!.substring(4, 5);
            sixth.text = credential.smsCode!.substring(5, 6);
            /*otpNo.text = firstDigit.text + secondDigit.text + thirdDigit.text +
                fourthDigit.text + fifthDigit.text + sixthDigit.text;*/
          });




          print(sendOtp);
        },
        verificationFailed: (FirebaseAuthException e) async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please try again later")));
        },

        codeSent: (String verificationId, int? resendingToken) {
          verificationCode = verificationId;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification Code sent on your phone number")));
          /*wait=true;
          startTimer();*/
        },
        codeAutoRetrievalTimeout: (String verificationId) async {

          verificationCode = verificationId;


        });
  }
  @override
  void initState() {
  verifyNumber(context);
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
        backgroundColor: Color(0xFF1B1F20),
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
                  Text("Enter the 4-digit code send to",style: GoogleFonts.inter(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("+91 ${widget.mobile}",style: GoogleFonts.inter(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,
                      child: TextFormField(
                        autofocus:true,
                        controller: first,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,

                      child: TextFormField(
                        autofocus:true,
                        controller: second,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,

                      child: TextFormField(
                        autofocus:true,
                        controller: third,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,

                      child: TextFormField(
                        autofocus:true,
                        controller: fourth,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,

                      child: TextFormField(
                        autofocus:true,
                        controller: fifth,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,
                      child: TextFormField(
                        autofocus:true,
                        controller: sixth,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled:true,
                          fillColor: Color(0xFF1B1F20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:40.0,horizontal: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 80,vertical: 20)),
                  ),
                  onPressed: () async{
                    if(formKey.currentState!.validate()){

                     await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: first.text+second.text+third.text+fourth.text+fifth.text+sixth.text)).then((value){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const DashBoardScreen(title: "MT OTT")));

                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successfully")));
                     });
                    }
                  }, child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Continue",style: GoogleFonts.inter(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600)),
                      const Icon(Icons.keyboard_arrow_right,color: Colors.white),
                    ]),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
