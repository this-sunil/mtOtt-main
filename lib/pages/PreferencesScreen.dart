import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/main.dart';


import '../utility/theme/ThemeCubit.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  double currentValue=0.0;
  double maxValue=0.0;
  bool trailer=false;
  String qualityTitle="Auto";
  HashSet<String> selectItem=HashSet<String>();
  multipleSelect(String title){
    if(selectItem.length==2){
      selectItem.remove(title);
    }
    else{
      selectItem.clear();
      selectItem.add(title);
      qualityTitle=selectItem.first;

    }
    setState(() {

    });
  }
/*  fetchStorageInfo() async{

    selectItem.add("$qualityTitle");
// get internal storage total space in bytes, MB and GB
    currentValue=await StorageInfo.getStorageUsedSpaceInGB;
    maxValue=await StorageInfo.getStorageTotalSpaceInGB; // return double

    print("Current Value $currentValue");
    print("Max Value $maxValue");
   setState(() {

   });

  }*/
  @override
  void initState() {
    //fetchStorageInfo();
    super.initState();
  }
 /* @override
  void didUpdateWidget(covariant PreferencesScreen oldWidget) {
    setState(() {
      fetchStorageInfo();
    });
    super.didUpdateWidget(oldWidget);
  }*/
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  showVideoQuality() async{
    return showModalBottomSheet(

        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
        context: context,
        builder: (context){
      return StatefulBuilder(
        builder: (context,setState){
         return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
            color: Color(0XFF1B1F20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text("Select Video Quality",style: GoogleFonts.inter(color: Colors.white)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){

                    Navigator.pop(context);
                    qualityTitle="Auto";
                    multipleSelect(qualityTitle);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Auto",style: GoogleFonts.inter(color: Colors.white)),

                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                   setState((){

                     Navigator.pop(context);
                     qualityTitle="1080";
                     multipleSelect(qualityTitle);
                   });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Full HD upto 1080p",style: GoogleFonts.inter(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: Text("SUBSCRIBE",style: TextStyle(color: Colors.yellow))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState((){

                      Navigator.pop(context);
                      qualityTitle="720";
                      multipleSelect(qualityTitle);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Full HD upto 720p",style: GoogleFonts.inter(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: Text("SUBSCRIBE",style: TextStyle(color: Colors.yellow))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState((){

                      Navigator.pop(context);
                      qualityTitle="480";
                      multipleSelect(qualityTitle);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("SD upto 480p",style: GoogleFonts.inter(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: Text("SUBSCRIBE",style: TextStyle(color: Colors.yellow))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:  AppBar(

        leading: IconButton(

            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Settings"),

      ),
      body: Column(
        children: [
        SwitchListTile(value: flag, title: Text("Theme"),onChanged: (val){
         setState(() {
           flag=val;
           context.read<ThemeCubit>().toggleTheme();
         });

        }),
        ],
      ),
     /* Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
            child: Row(
              children: [
                Text("Video",style: GoogleFonts.inter(color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Card(
              color: Color(0XFF1B1F20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Always Trailers",style: GoogleFonts.inter(color: Colors.white)),
                        Switch(value: trailer, onChanged: (value){
                          setState(() {
                            trailer=value;
                          });
                        }),
                      ],
                    ),
                  ),
                  Divider(color:Colors.black54,height: 0),
                  InkWell(
                    onTap: (){
                      showVideoQuality();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Preferred Video Quality",style: GoogleFonts.inter(color: Colors.white)),
                          Row(
                            children: [
                              Text(qualityTitle,style: GoogleFonts.inter(color: Colors.white)),
                              Icon(Icons.keyboard_arrow_down,color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Row(
            children: [
              Text("Download",style: GoogleFonts.inter(color: Colors.white)),
            ],
          ),
        ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Color(0XFF1B1F20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      showVideoQuality();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Default Download Quality",style: GoogleFonts.inter(color: Colors.white)),
                          Icon(Icons.keyboard_arrow_down,color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  Divider(color:Colors.black54,height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 20),
                    child: Row(
                      children: [
                        Text("Internal Storage",style: GoogleFonts.inter(color: Colors.white)),


                      ],
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:20.0,left: 15,right: 15),
                    child: FAProgressBar(

                      backgroundColor: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                      size: 5,
                      animatedDuration: Duration(seconds: 2),
                      currentValue:currentValue,
                      direction: Axis.horizontal,
                      maxValue: maxValue,
                      progressColor: Colors.white,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey,width: 1.0)
                                ),
                              ),
                            ),
                            Text("Used $currentValue GB",style: GoogleFonts.inter(color: Colors.white)),
                          ],
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Color(0XFF1B1F20),
                                  border: Border.all(color: Colors.grey,width: 1.0)
                                ),
                                ),
                            ),
                            Text("Available ${maxValue.roundToDouble()-currentValue.roundToDouble()} GB",style: GoogleFonts.inter(color: Colors.white)),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      )*/
    );
  }
}
