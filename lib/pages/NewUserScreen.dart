import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/pages/VerificationScreen.dart';
class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  TextEditingController mobile=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey();
  @override
  void initState() {

    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("New to Hotstar",style: GoogleFonts.inter(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Verify mobile number to create account",style: GoogleFonts.inter(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:20,horizontal: 20),
              child: TextFormField(
                autofocus: true,
                controller: mobile,
                cursorHeight: 35,
                maxLength: 10,
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
                    Navigator.push(context,PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) => const VerificationScreen(mobile: "86846746367"),
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
