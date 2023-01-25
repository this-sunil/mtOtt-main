/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
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

        title: Text("My Account"),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(


            children: [
              Center(child: SvgPicture.asset("asset/logo/user.svg",width: 100,height: 100)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Sunil Shedge",style: GoogleFonts.inter(color: Colors.white,fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text("+91 8799887888",style: GoogleFonts.inter(color: Color(0xFF707070)),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 8),
                child: Row(
                  children: [
                    Text("MEMBERSHIP",style: GoogleFonts.inter(color: Color(0xFF707070)),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: const Color(0xFF1B1F20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 15),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text("Get more with Disney+ Hotstar Premium",style: GoogleFonts.inter(color: Colors.white,fontSize: 18)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0,horizontal:8.0),
                          child: Row(
                            children: [
                              Text("Only ₹1499/year",style: GoogleFonts.inter(color: Color(0xFF707070))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:10.0),
                          child: ElevatedButton(
                              style:ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                                backgroundColor: MaterialStateProperty.all(Color(0xFF1F80DF))
                              ),
                              onPressed: (){}, child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Get Disney+ Hotstar Premium"),
                                  Icon(Icons.keyboard_arrow_right),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 8),
                child: Row(
                  children: [
                    Text("ACCOUNT AND SECURITY",style: GoogleFonts.inter(color: Color(0xFF707070)),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: const Color(0xFF1B1F20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Account Settings",style: GoogleFonts.inter(color: Colors.white,fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: const Color(0xFF1B1F20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Manage Devices",style: GoogleFonts.inter(color: Colors.white,fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: const Color(0xFF1B1F20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Log out",style: GoogleFonts.inter(color: Colors.white,fontSize: 16)),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Log out All Devices",style: GoogleFonts.inter(color: Colors.white,fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
*/
