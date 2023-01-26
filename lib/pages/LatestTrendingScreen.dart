import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../Service/cubit/LatestMovieCubit.dart';
import '../Service/state/LatestMoviesState.dart';
import '../const.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import 'DetailsScreen.dart';
import 'SearchScreen.dart';
class LatestTrendingScreen extends StatefulWidget {
  const LatestTrendingScreen({Key? key}) : super(key: key);

  @override
  State<LatestTrendingScreen> createState() => _LatestTrendingScreenState();
}

class _LatestTrendingScreenState extends State<LatestTrendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
        title: const Text("Latest & Trending"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black))
        ],
      ),
      body: BlocBuilder<LatestMovieCubit,LatestMovieState>(

          builder: (context,state){
            if(state is LatestMovieLoadedState){
              return AnimationLimiter(

                child: GridView.builder(

                    itemCount: state.slider.length,

                    physics: const BouncingScrollPhysics(),

                    itemBuilder: (context,index){
                      return AnimationConfiguration.staggeredGrid(

                        position: index,
                        duration: const Duration(seconds: 1),
                        columnCount: 3,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: (){
                            if(planBuy==false || state.slider[index].data[index].price!="0"){
                              Navigator.push(context,PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                pageBuilder: (context, animation, secondaryAnimation) =>  const PlanScreen(),
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
                            else{
                              Navigator.push(context,PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                pageBuilder: (context, animation, secondaryAnimation) =>  DetailsScreen(id: state.slider[index].data[index].id,url: state.slider[index].data[index].movieUrl, title: state.slider[index].data[index].movieTitle,  type: state.slider[index].data[index].movieType, imgPath: "$baseUrl/images/movies/${state.slider[index].data[index].moviePoster}", seriesId:'', description:state.slider[index].data[index].movieDesc, mType: 'movie',),
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

                          },
                          child: SlideAnimation(
                            verticalOffset: 1000,
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOutSine,
                            delay: const Duration(seconds: 1),
                            child: FadeInAnimation(

                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(

                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("$baseUrl/images/movies/${state.slider[index].data[index].movieCover}"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: .8)),
              );
            }
            return ListView.builder(

                itemCount: 5,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),

                itemBuilder: (context,index){
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFFF7F8F8),

                    highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 400,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:  BorderRadius.circular(12),

                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
