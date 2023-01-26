import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/const.dart';
import 'package:mtott/main.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Service/cubit/PopularCubit.dart';
import '../Service/cubit/SearchCubit.dart';
import '../Service/state/PopularState.dart';
import '../plan/PlanScreen.dart';
import 'ChannelScreen.dart';
import 'DetailsScreen.dart';
import 'GeneresScreen.dart';
import 'LanguageScreen.dart';

class InitialSearchScreen extends StatefulWidget {
  final String search;
  const InitialSearchScreen({Key? key,required this.search}) : super(key: key);

  @override
  State<InitialSearchScreen> createState() => _InitialSearchScreenState();
}

class _InitialSearchScreenState extends State<InitialSearchScreen> {
  List<String> popularList=[
    "Anupama",
    "Koffee With Karan",
    "Aai Kuthe Kaay Karte",
    "Ghum Hai Kisikey",
    "Modern Family",
  ];
  TextEditingController search=TextEditingController();
  late SpeechToText speechToText;
  bool isListening=false;
  String text="I am Listening ....";
  double confidence=1.0;
  speechtoText() async{
    if(!isListening){
      bool available=await speechToText.initialize(
          onError: (val)=>print("Error speech to text $val"),
          onStatus: (val)=>print("Status Speech to Text $val")
      );
      if(available){
        setState(() {
          isListening=true;
          search.text=text;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mic is On"),duration: Duration(seconds: 2)));
        });
        speechToText.listen(
            onResult: (val){
              setState(() {
                search.text=val.recognizedWords;

                if(val.hasConfidenceRating && val.confidence>0){
                  confidence=val.confidence;
                }
              });
            }
        ).then((value){
          Navigator.pop(context);
        });

      }

    }
  }
  @override
  void initState() {
    speechToText=SpeechToText();
    super.initState();
  }
  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),

        children: [
          recentSearch.isNotEmpty?Padding(
            padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 15),
            child: Row(
              children: [
                Text("Recent Search",style: GoogleFonts.inter(color: const Color(0xFF707070),fontWeight: FontWeight.w600)),
              ],
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: recentSearch.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(recentSearch[index]),
                    onTap: (){
                      context.read<SearchCubit>().searchMovies(recentSearch[index]);
                    },
                    trailing: IconButton(onPressed: (){
                     setState(() {
                       recentSearch.removeAt(index);
                     });
                    }, icon: const Icon(Icons.clear)),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 15),
            child: Row(
              children: [
                Text("Browse",style: GoogleFonts.inter(color: const Color(0xFF707070),fontWeight: FontWeight.w600))
              ],
            ),
          ),
          ListTile(
            leading: IconButton(onPressed: (){}, icon: SvgPicture.asset("asset/logo/channel.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
            title: const Text("Channel"),
            onTap: (){
              Navigator.push(context,PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>  const ChannelScreen(),
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
            subtitle: const Text("StarPlus, Star Jalsha and more"),
          ),
          ListTile(
            leading: IconButton(onPressed: (){}, icon: SvgPicture.asset("asset/logo/generes.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),
            title: const Text("Genres"),
            onTap: (){
              Navigator.push(context,PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>  const GenresScreen(),
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
            subtitle: const Text("Romance, Drama and more"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 15),
            child: Row(
              children: [
                Text("Popular",style: GoogleFonts.inter(color: Color(0xFF707070),fontWeight: FontWeight.w600))
              ],
            ),
          ),
          BlocBuilder<PopularCubit,PopularState>(

              builder: (context,state){
                if(state is LoadedPopularState){
                  return ListView.builder(

                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.slider.length,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            if (planBuy == false || state.slider[index].data[index].price!="0") {
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
                                      id: state.slider[index].data[index].id,
                                      url: state.slider[index].data[index]
                                          .movieUrl,
                                      title: state.slider[index].data[index]
                                          .movieTitle,
                                      description: state.slider[index]
                                          .data[index].movieDesc,
                                      type: state.slider[index].data[index]
                                          .movieType,
                                      imgPath: "$baseUrl/images/movies/${state
                                          .slider[index].data[index]
                                          .moviePoster}",
                                      seriesId: '',
                                      mType: 'movie',),
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(

                              children: [
                                ClipRRect(
                                    borderRadius:BorderRadius.circular(5),
                                    child: Image.network("$baseUrl/images/movies/${state.slider[index].data[index].movieCover}",width: 60,height: 60,fit: BoxFit.cover)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                                  child: Text(state.slider[index].data[index].movieTitle),
                                ),
                              ],

                            ),
                          ),
                        );
                      });
                }
                return Center(child: CircularProgressIndicator());

          })
        ],
      ),
    );
  }
}
