import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mtott/pages/ChannelScreen.dart';
import 'package:mtott/pages/DownloadScreen.dart';
import 'package:mtott/pages/FavouriteMusicScreen.dart';
import 'package:mtott/pages/GeneresScreen.dart';
import 'package:mtott/pages/HelpScreen.dart';
import 'package:mtott/pages/HomeScreen.dart';
import 'package:mtott/pages/MoviesScreen.dart';
import 'package:mtott/pages/PreferencesScreen.dart';
import 'package:mtott/pages/SearchScreen.dart';
import 'package:mtott/pages/SignInScreen.dart';
import 'package:mtott/pages/WatchListScreen.dart';
import 'package:mtott/pages/WebseriesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/cubit/InternetCubit.dart';
import '../main.dart';
import 'DownloadTask.dart';
import 'InternetConnection.dart';
import 'MusicScreen.dart';
import 'package:google_fonts/google_fonts.dart';
class DashBoardScreen extends StatefulWidget {
  final String title;
  const DashBoardScreen({Key? key,required this.title}) : super(key: key);
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with WidgetsBindingObserver{

  late Widget currentPage;
  int currentIndex=0;
  FirebaseAuth auth=FirebaseAuth.instance;
  HomeScreen homeScreen=HomeScreen();
  MoviesScreen moviesScreen=MoviesScreen();
  WebSeriesScreen webSeriesScreen=WebSeriesScreen();
  MusicScreen musicScreen=MusicScreen();
  List<Widget> pages=[];
  bool flag=true;
  String username="";
  String image="";
  fetchData() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    username=pref.getString("fullName").toString();
    setState(() {

    });
  }
  GlobalKey<ScaffoldState> drawerKey=GlobalKey();

  @override
  void initState() {
    fetchData();
    pages=[homeScreen,moviesScreen,webSeriesScreen,musicScreen];
    currentPage=pages[currentIndex];

    /*if(FacebookAuth.instance.accessToken!=null){
      var userData=FacebookAuth.instance.getUserData();
      userData.then((value) {
        setState(() {
          username=value["name"];
          image=value["picture"]["data"]["url"];
        });
        print(value);
      });
    }*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit,InternetState>(
        builder: (context,state){
          if(state == InternetState.internetSuccess){
            return Scaffold(
              key:drawerKey,

              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      drawerKey.currentState!.openDrawer();
                    },
                    icon: SvgPicture.asset("asset/logo/menu.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
                title: Text(widget.title,style: GoogleFonts.inter(fontSize: 20)),
                actions: [
                  IconButton(
                      onPressed: () {

                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
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
                      },
                      icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: ListTile(
                        leading:auth.currentUser==null?SvgPicture.asset("asset/logo/user.svg"):CircleAvatar(backgroundImage: NetworkImage("${auth.currentUser!.photoURL}")),
                        title: Text(username.isEmpty?"Log In":username),
                        subtitle: const Text("For a better experience"),
                        trailing:  SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                        onTap: username.isEmpty?(){
                          Navigator.push(context,PageRouteBuilder(
                            transitionDuration: const Duration(seconds: 1),
                            pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
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
                        }:(){},
                      ),
                    ),
                    ListTile(
                      leading:Image.asset("asset/logo/download.png",width: 20,height: 20,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      title: const Text("Download"),
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) =>  MyDownload(platform: Theme.of(context).platform),
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
                      },
                    ),
                    ListTile(
                      leading:SvgPicture.asset("asset/logo/watchlist.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      title: const Text("Watch List"),
                      onTap: (){
                        Navigator.push(context,PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const WatchListScreen(),
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
                      },
                    ),
                   /* ListTile(
                      leading:SvgPicture.asset("asset/logo/gift.svg"),
                      title: Text("Prizes",style:GoogleFonts.inter(color: Colors.white)),
                      onTap: (){
                        setState(() {
                          flag=false;
                          drawerKey.currentState!.closeDrawer();
                          drawerKey.currentState!.showBottomSheet(
                              elevation: 10,
                              backgroundColor: const Color(0xFF1B1F20),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20)),
                              ),(context) {
                            return Dismissible(
                              direction: DismissDirection.down,
                              onDismissed: (direction){
                                setState(() {
                                  flag=true;
                                });
                              },
                              key:UniqueKey(),
                              child: Card(
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20)),
                                ),
                                color: const Color(0xFF1B1F20),
                                child:Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(onPressed: (){
                                          setState(() {
                                            flag=true;
                                            Navigator.pop(context);
                                          });

                                        }, icon: Icon(Icons.close,color: Colors.white)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("My Prizes",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("You’ve yet to win your first prize. Play watch’NPlay with",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("any live match to win awesome Prizes!",style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.white)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 150,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        });
                      },
                    ),*/

                    ListTile(
                      leading:SvgPicture.asset("asset/logo/channel.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const ChannelScreen(),
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
                      },
                      title: Text("Channels"),
                    ),
                    /*ListTile(
                      leading:SvgPicture.asset("asset/logo/language.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      onTap: (){
                        Navigator.push(context,PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const LanguageScreen(),
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
                      },
                      title: Text("Language"),
                    ),*/
                    ListTile(
                      leading:SvgPicture.asset("asset/logo/generes.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      onTap: (){
                        Navigator.push(context,PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const GeneresScreen(),
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
                      },
                      title: Text("Genres"),
                    ),
                    ListTile(
                      leading:SvgPicture.asset("asset/logo/setting.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      onTap: (){
                        Navigator.push(context,PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const PreferencesScreen(),
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
                      },
                      title: Text("Settings"),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const FavouriteMusicScreen(),
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
                      },
                      leading:Icon(Icons.favorite_border,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      title: Text("Favourite"),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const HelpScreen(),
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
                      },
                      leading:SvgPicture.asset("asset/logo/help.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                      title: const Text("Help"),
                    ),
                    username.isNotEmpty?ListTile(
                      onTap: () async{
                        SharedPreferences pref=await SharedPreferences.getInstance();
                        pref.remove("fullName");
                        pref.remove("uid");
                        await FacebookAuth.instance.logOut().then((value){
                          auth.signOut();
                          FacebookAuth.instance.logOut();
                        });
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const SignInScreen()));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Log Out SuccessFully")));
                      },
                      leading: Icon(Icons.logout_outlined,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,size: 24),
                      title: const Text("Log Out"),
                    ):Container(),

                  ],
                ),
              ),
              body: currentPage,



              bottomNavigationBar: Visibility(
                visible: flag,
                child: BottomNavigationBar(
                  elevation: 0,
                  currentIndex: currentIndex,
                  selectedLabelStyle: TextStyle(color: Colors.white),

                  unselectedLabelStyle: TextStyle(color: Colors.grey),

                  showSelectedLabels: true,

                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.amber,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,

                  onTap: (int  index){
                    setState(() {
                      currentIndex=index;
                      currentPage=pages[currentIndex];
                    });
                  },
                  items: [
                    BottomNavigationBarItem(icon:Icon(Icons.home),label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined),label: "Movies"),
                    BottomNavigationBarItem(icon: Icon(Ionicons.videocam_outline),label: "WebSeries"),
                    BottomNavigationBarItem(icon: Icon(MaterialIcons.library_music),label: "Music"),
                  ],
                ),
              ),
            );
          }
          return const InternetConnection();
        });

  }
}
