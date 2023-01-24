import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/const.dart';
import 'package:mtott/plan/SuperPlanScreen.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Choose your plan.",style: GoogleFonts.inter(fontSize: 24)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              children:  [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check),
                ),
                Text("No commitments,cancel \nanytime.",style: GoogleFonts.inter(fontSize: 18))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              children:  [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check),
                ),
                Text("Everything on $appName for one \nlow price.",style: GoogleFonts.inter(fontSize: 18))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              children:  [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check),
                ),
                Text("No Ads and no extra fee.Ever",style: GoogleFonts.inter(fontSize: 18))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              extendedPadding: const EdgeInsets.symmetric(horizontal: 150,vertical: 10),
              label: const Text("Next"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SuperPlanScreen()));
                }),
          ),
        ],
      ),
    );
  }
}
