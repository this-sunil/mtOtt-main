import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html;
import 'package:lottie/lottie.dart';
import 'package:mtott/Service/cubit/SearchCubit.dart';
import 'package:mtott/Service/state/SearchState.dart';
import 'package:mtott/const.dart';
import 'package:mtott/main.dart';
import 'package:mtott/pages/DetailsScreen.dart';
import 'package:mtott/pages/InitialSearchScreen.dart';
import 'package:mtott/pages/SearchMusicScreen.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Service/cubit/MusicCategoryTypeCubit.dart';
import '../plan/PlanScreen.dart';
import 'TVSeriesScreen.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SpeechToText speechToText;
  bool isListening=false;
  TextEditingController search=TextEditingController();
  String text="I am Listening ....";
  double confidence=1.0;
  List<String> popularList=[
    "Anupama",
    "Koffee With Karan",
    "Aai Kuthe Kaay Karte",
    "Ghum Hai Kisikey",
    "Modern Family",
  ];
  speechtoText() async{
    if(!isListening){
      bool available=await speechToText.initialize(
        onError: (val)=>print("Error speech to text $val"),
        onStatus: (val)=>print("Status Speech to Text $val")
      );
      if(available){
        setState(() {
          isListening=true;
          speechToText.listen(
              onResult: (val){
                setState(() {
                  search.text=val.recognizedWords;
                  context.read<SearchCubit>().searchMovies(search.text);

                  if(val.hasConfidenceRating && val.confidence>0){
                    confidence=val.confidence;
                  }
                });
              }
          ).then((value){
            Navigator.pop(context);
          });
          //search.text=text;
          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mic is On"),duration: Duration(seconds: 2)));
        });


      }
      else{
        isListening=false;
      }

    }
  }
  searchData(String text) async{
    print("Search Here $text");
  }
  @override
  void initState() {
    speechToText=SpeechToText();
    context.read<SearchCubit>().searchMovies("");
    super.initState();
  }
  @override
  void dispose() {
    search.dispose();
    speechToText.stop();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(5),
                    color: Theme.of(context).brightness == Brightness.dark?const Color(0xFF1B1F20):const Color(0xFFF0ECE3),
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: search,
                      onChanged: (val){
                        setState(() {
                          BlocProvider.of<SearchCubit>(context).searchMovies(val);
                        });
                      },
                      onFieldSubmitted: (value){
                        setState(() {
                          BlocProvider.of<SearchCubit>(context).searchMovies(value);
                          if(value.isNotEmpty){
                            recentSearch.add(value);
                          }
                        });
                      },
                      style: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                      textInputAction: TextInputAction.search,
                      cursorColor:  Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
                        hintText: "Search",
                        hintStyle: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                        suffixIcon: IconButton(onPressed: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            contentPadding: EdgeInsets.symmetric(horizontal: 100),
                            title: Center(child: Text("Google",style: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontWeight: FontWeight.w500,fontSize: 20))),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AvatarGlow(
                                  animate: isListening,
                                  endRadius: 75.0,
                                  glowColor: Theme.of(context).primaryColor,
                                  repeat: true,
                                  duration: Duration(milliseconds: 2000),
                                  repeatPauseDuration: Duration(milliseconds: 200),
                                  child: FloatingActionButton(
                                      backgroundColor: Colors.blue,
                                      onPressed: (){
                                        setState((){
                                          if(isListening==false){
                                            isListening=true;
                                            speechtoText();
                                          }
                                          else{
                                            isListening=false;
                                            //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mic is Off"),duration: Duration(seconds: 2),));
                                            speechToText.stop();
                                            search.clear();
                                          }
                                        });
                                      }, child: Icon(isListening?Icons.mic:Icons.mic_off,color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
                                ),
                                Flexible(child: Padding(
                                      padding: const EdgeInsets.only(bottom:20.0),
                                      child: Text(isListening?"I am Listen....":"Tap on Mic",
                                          overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ),
                          ));
                        }, icon: SvgPicture.asset("asset/logo/mic.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<SearchCubit,SearchState>(builder: (context,state){
                  if(state is LoadedStates){
                    return Column(
                      children: [
                        state.slider[0].searchResponse.movies.isNotEmpty?Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Top Results",style: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontSize: 16)),
                            ],
                          ),
                        ):Container(),
                        state.slider[0].searchResponse.movies.isNotEmpty?AnimationLimiter(
                          child: ListView.builder(

                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                            itemBuilder: (context,index){
                            print("Search State Length ${state.slider.length}");
                          return InkWell(
                            onTap: (){
                              if (planBuy == false && state.slider[0].searchResponse.movies[index].price!="0") {
                                Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: const Duration(
                                      seconds: 1),
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) => const PlanScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;
                                    var tween = Tween(
                                        begin: begin, end: end).chain(
                                        CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                              }
                              else {
                                Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: const Duration(seconds: 1),
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                      DetailsScreen(
                                          title: state.slider[0].searchResponse
                                              .movies[index].movieTitle,
                                          url: state.slider[0].searchResponse
                                              .movies[index].movieUrl,
                                          id: state.slider[0].searchResponse
                                              .movies[index].id,
                                          description: state.slider[0]
                                              .searchResponse.movies[index]
                                              .movieDesc,
                                          type: state.slider[0].searchResponse
                                              .movies[index].movieType,
                                          mType: 'movie',
                                          imgPath: "$baseUrl/images/movies/${state
                                              .slider[0].searchResponse
                                              .movies[index].moviePoster}",
                                          seriesId: ''),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                              }
                            },
                            child: AnimationConfiguration.staggeredList(
                              position: index,
                              child: SlideAnimation(
                                horizontalOffset: 1000,
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeInOutSine,
                                delay: const Duration(seconds: 1),
                                child: FadeInAnimation(
                                  child: Card(
                                    elevation: 5,

                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                                    child:Row(
                                      children: [
                                        Container(
                                          width: 125,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)
                                            ),
                                            image: DecorationImage(

                                                fit: BoxFit.cover,

                                                image:NetworkImage("$baseUrl/images/movies/${state.slider[0].searchResponse.movies[index].moviePoster}")
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(state.slider[0].searchResponse.movies[index].movieTitle),

                                                Text(html.parse(state.slider[0].searchResponse.movies[index].movieDesc).body!.text),
                                              ],
                                            ),
                                          ),
                                        )

                                      ],
                                    )),
                                ),
                              ),
                            ),
                          );
                  }, itemCount: state.slider[0].searchResponse.movies.length),
                        ):Container(),
                       state.slider[0].searchResponse.series.isNotEmpty? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Text("Series",style: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontSize: 16)),
                            ],
                          ),
                        ):Container(),
                        state.slider[0].searchResponse.series.isNotEmpty?AnimationLimiter(
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                print("Search State Length ${state.slider.length}");
                                return InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: (){
                                    Navigator.push(context,PageRouteBuilder(
                                      transitionDuration: const Duration(seconds: 1),
                                      pageBuilder: (context, animation, secondaryAnimation) =>  TvSeriesScreen(id: state.slider[0].searchResponse.series[index].id,title: state.slider[0].searchResponse.series[index].seriesName,description: state.slider[0].searchResponse.series[index].seriesDesc,imgPath: '$baseUrl/images/series/${state.slider[0].searchResponse.series[index].seriesCover}', seasonId: state.slider[0].searchResponse.series[index].seasonData[0].id),
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
                                  child: AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    columnCount: 3,
                                    
                                    child: SlideAnimation(
                                      horizontalOffset: 500,
                                      duration: const Duration(seconds: 2),
                                      curve: Curves.easeInOutSine,
                                      delay: const Duration(seconds: 1),
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Card(
                                            elevation: 10,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            color:  const Color(0xFF1B1F20),
                                            child:Container(
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: NetworkImage("$baseUrl/images/series/${state.slider[0].searchResponse.series[index].seriesPoster}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }, itemCount: state.slider[0].searchResponse.series.length, gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 1)),
                        ):Container(),
                        state.slider[0].searchResponse.channels.isNotEmpty?Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Text("Channels",style: GoogleFonts.inter(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontSize: 16)),
                            ],
                          ),
                        ):Container(),
                        state.slider[0].searchResponse.channels.isNotEmpty?SizedBox(
                          height: 160,
                          child: AnimationLimiter(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index){

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){

                                        Navigator.push(context, PageRouteBuilder(
                                          transitionDuration: const Duration(
                                              seconds: 1),
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                              DetailsScreen(
                                                title: state.slider[0]
                                                    .searchResponse
                                                    .channels[index].channelTitle,
                                                url: "$baseUrl/${state.slider[0]
                                                    .searchResponse
                                                    .channels[index]
                                                    .channelPoster}",
                                                id: state.slider[0].searchResponse
                                                    .channels[index].id,
                                                description: state.slider[0]
                                                    .searchResponse
                                                    .channels[index].channelDesc,
                                                type: state.slider[0]
                                                    .searchResponse
                                                    .channels[index].channelType,
                                                imgPath: "$baseUrl/images/${state
                                                    .slider[0].searchResponse
                                                    .channels[index]
                                                    .channelPoster}",
                                                seriesId: '',
                                                mType: '',),
                                          transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            var tween = Tween(
                                                begin: begin, end: end).chain(
                                                CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                        ));

                                    },
                                    child: AnimationConfiguration.staggeredList(
                                      position: index,
                                      child: ScaleAnimation(
                                        scale: .4,
                                        duration: const Duration(seconds: 2),
                                        curve: Curves.easeInOutSine,
                                        delay: const Duration(seconds: 1),
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Column(
                                              children: [
                                                PhysicalModel(
                                                  color: Colors.black,
                                                  elevation: 10.0,
                                                  shape: BoxShape.circle,
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: Colors.white,
                                                    backgroundImage: NetworkImage("$baseUrl/images/${state.slider[0].searchResponse.channels[index].channelPoster}"),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Text(state.slider[0].searchResponse.channels[index].channelTitle),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }, itemCount: state.slider[0].searchResponse.channels.length),
                          ),
                        ):Container(),
                        state.slider[0].searchResponse.songs.isNotEmpty?Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text("Songs",style: GoogleFonts.inter(color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontSize: 16)),
                            ],
                          ),
                        ):Container(),
                        state.slider[0].searchResponse.songs.isNotEmpty?AnimationLimiter(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                print("Search State Length ${state.slider.length}");
                                return InkWell(
                                  onTap: (){
                                    debugPrint("Type of Music ${state.slider[0].searchResponse.songs[index].musicType}");
                                    if(state.slider[0].searchResponse.songs.isNotEmpty){
                                     setState(() {
                                       context.read<MusicCategoryTypeCubit>().fetchMusicCategoryType(state.slider[0].searchResponse.songs[index].musicType);
                                       Navigator.push(context,PageRouteBuilder(
                                         transitionDuration: const Duration(seconds: 1),
                                         pageBuilder: (context, animation, secondaryAnimation) =>
                                             SearchMusicScreen(id: state.slider[0].searchResponse.songs[index].id,title: state.slider[0].searchResponse.songs[index].title,
                                                 url: "$baseUrl/${state.slider[0].searchResponse.songs[index].music}",
                                                 type:  state.slider[0].searchResponse.songs[index].musicType, imgPath: state.slider[0].searchResponse.songs[index].musicCover, singer: state.slider[0].searchResponse.songs[index].singer),
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
                                     });

                                    }
                                  },
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    child:SlideAnimation(
                                      horizontalOffset: 1000,
                                      duration: const Duration(seconds: 2),
                                      curve: Curves.easeInOutSine,
                                      delay: const Duration(seconds: 1),
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Card(

                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            child:ListTile(leading: CircleAvatar(
                                              maxRadius: 25,
                                              backgroundImage: NetworkImage("$baseUrl/${state.slider[0].searchResponse.songs[index].musicCover}"),
                                            ),
                                              title: Text(state.slider[0].searchResponse.songs[index].title),
                                              subtitle: Text(state.slider[0].searchResponse.songs[index].singer),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }, itemCount: state.slider[0].searchResponse.songs.length),
                        ):Container(),


                      ],
                    );
                  }
                  return search.text.isEmpty?InitialSearchScreen(search: search.text): NoResultScreen(search: search.text);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
class NoResultScreen extends StatelessWidget {
  final String search;
  const NoResultScreen({Key? key,required this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [

          Lottie.asset("asset/image/no-search.json"),
          Text("Couldn't find '$search'",style: GoogleFonts.inter(fontSize: 20)),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Try searching for something else or try",style: GoogleFonts.inter(fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("with a different spelling",style: GoogleFonts.inter(fontSize: 15)),
          ),

        ],
      ),
    );
  }
}

