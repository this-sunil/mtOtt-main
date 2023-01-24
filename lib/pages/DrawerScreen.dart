// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'ChannelScreen.dart';
// import 'DownloadScreen.dart';
// import 'GeneresScreen.dart';
// import 'LanguageScreen.dart';
// import 'PreferencesScreen.dart';
// import 'SignInScreen.dart';
// import 'WatchListScreen.dart';
// /*Drawer Screen*/
// class DrawerScreen extends StatefulWidget {
//   const DrawerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DrawerScreen> createState() => _DrawerScreenState();
// }
//
// class _DrawerScreenState extends State<DrawerScreen> {
//   bool flag=true;
//   String username="";
//   String image="";
//   GlobalKey<DrawerControllerState> drawerKey=GlobalKey();
//   @override
//   void initState() {
//     if(FacebookAuth.instance.accessToken!=null){
//       var userData=FacebookAuth.instance.getUserData();
//       userData.then((value) {
//         setState(() {
//           username=value["name"];
//           image=value["picture"]["data"]["url"];
//         });
//         print(value);
//       });
//     }
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return
//       Drawer(
//       key: drawerKey,
//       backgroundColor: Colors.black,
//       child: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 40),
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical:8.0),
//             child: ListTile(
//               leading:image.isEmpty?SvgPicture.asset("asset/logo/user.svg"):CircleAvatar(backgroundImage: NetworkImage("$image")),
//               title: Text(username.isEmpty?"Log In":username,style:GoogleFonts.inter(color: Colors.white,fontSize: 20)),
//               subtitle: Text("For a better experience",style:GoogleFonts.inter(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500)),
//               trailing:  SvgPicture.asset("asset/logo/rightarrow.svg"),
//               onTap: (){
//                 Navigator.push(context,PageRouteBuilder(
//                   transitionDuration: Duration(seconds: 1),
//                   pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
//                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                     const begin = Offset(0.0, 1.0);
//                     const end = Offset.zero;
//                     const curve = Curves.ease;
//                     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ));
//               },
//             ),
//           ),
//           ListTile(
//             leading:Image.asset("asset/logo/download.png",width: 20,height: 20),
//             title: Text("Download",style:GoogleFonts.inter(color: Colors.white)),
//             onTap: (){
//               Navigator.push(context, PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const DownloadScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/watchlist.svg"),
//             title: Text("Watch List",style:GoogleFonts.inter(color: Colors.white)),
//             onTap: (){
//               Navigator.push(context,PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const WatchListScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/gift.svg"),
//             title: Text("Prizes",style:GoogleFonts.inter(color: Colors.white)),
//             onTap: (){
//               setState(() {
//                 flag=false;
//                 drawerKey.currentState?.close();
//                showBottomSheet(
//                    context: context,
//                     elevation: 10,
//
//                     backgroundColor: Color(0xFF1B1F20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20)),
//                     ), builder:(context) {
//                   return Dismissible(
//                     direction: DismissDirection.down,
//                     onDismissed: (direction){
//                       setState(() {
//                         flag=true;
//                       });
//                     },
//                     key:UniqueKey(),
//                     child: Card(
//                       elevation: 10,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20)),
//                       ),
//                       color: Color(0xFF1B1F20),
//                       child:Column(
//                         mainAxisSize: MainAxisSize.min,
//
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//
//                               IconButton(onPressed: (){
//                                 setState(() {
//                                   flag=true;
//                                   Navigator.pop(context);
//                                 });
//
//                               }, icon: Icon(Icons.close,color: Colors.white)),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text("My Prizes",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white)),
//                               ],
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("You’ve yet to win your first prize. Play watch’NPlay with",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.white)),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("any live match to win awesome Prizes!",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.white)),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 150,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 });
//               });
//
//
//
//             },
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/channel.svg"),
//             onTap: (){
//               Navigator.push(context, PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const ChannelScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//             title: Text("Channels",style:GoogleFonts.inter(color: Colors.white)),
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/language.svg"),
//             onTap: (){
//               Navigator.push(context,PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const LanguageScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//             title: Text("Language",style:GoogleFonts.inter(color: Colors.white)),
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/generes.svg"),
//             onTap: (){
//               Navigator.push(context,PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const GeneresScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//             title: Text("Genres",style:GoogleFonts.inter(color: Colors.white)),
//           ),
//           ListTile(
//             leading:SvgPicture.asset("asset/logo/setting.svg"),
//             onTap: (){
//               Navigator.push(context,PageRouteBuilder(
//                 transitionDuration: Duration(seconds: 1),
//                 pageBuilder: (context, animation, secondaryAnimation) => const PreferencesScreen(),
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(0.0, 1.0);
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                   return SlideTransition(
//                     position: animation.drive(tween),
//                     child: child,
//                   );
//                 },
//               ));
//             },
//             title: Text("Preferences",style:GoogleFonts.inter(color: Colors.white)),
//           ),
//           ListTile(
//             onTap: (){},
//             leading:SvgPicture.asset("asset/logo/help.svg"),
//             title: Text("Help",style:GoogleFonts.inter(color: Colors.white)),
//           ),
//           username.isNotEmpty?ListTile(
//             onTap: () async{
//               SharedPreferences pref=await SharedPreferences.getInstance();
//               await FacebookAuth.instance.logOut().then((value){
//                 pref.remove("userId");
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Log Out SuccessFully")));
//                 Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const SignInScreen()));
//               });
//             },
//             leading:const Icon(Icons.logout_outlined,color: Colors.white,size: 24),
//             title: Text("Log Out",style:GoogleFonts.inter(color: Colors.white)),
//           ):Container(),
//
//         ],
//       ),
//     );
//   }
// }
