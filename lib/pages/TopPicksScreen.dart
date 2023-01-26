import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/DetailsScreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Service/cubit/TopPicksCubit.dart';
import '../Service/state/TopPicksState.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import 'SearchScreen.dart';
class TopPicksScreen extends StatefulWidget {
  const TopPicksScreen({Key? key}) : super(key: key);

  @override
  State<TopPicksScreen> createState() => _TopPicksScreenState();
}

class _TopPicksScreenState extends State<TopPicksScreen> {

  @override
  void initState() {
    context.read<TopPicksCubit>().fetchTopPicks();
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
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Top Picks For You"),
        actions: [
          IconButton(onPressed: (){
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black))
        ],
      ),
      body:BlocBuilder<TopPicksCubit,TopPicksState>(builder: (context,state){
        if(state is TopPicksLoadedState){
          return AnimationLimiter(
            child: GridView.builder(
                itemCount: state.slider.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: .8),
                itemBuilder: (context,index){
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: (){
                        if (planBuy == false || state.slider[index].topPicksResponse[index].price!="0") {
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
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              DetailsScreen(
                                id: state.slider[index].topPicksResponse[index].id,
                                url: state.slider[index].topPicksResponse[index]
                                    .movieUrl,
                                title: state.slider[index].topPicksResponse[index]
                                    .movieTitle,
                                description: state.slider[index]
                                    .topPicksResponse[index].movieDesc,
                                type: state.slider[index].topPicksResponse[index]
                                    .movieType,
                                imgPath: "$baseUrl/images/movies/${state
                                    .slider[index].topPicksResponse[index]
                                    .moviePoster}",
                                seriesId: '',
                                mType: 'movie')));
                        }
                      },
                      child: ScaleAnimation(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOutSine,
                        delay: const Duration(seconds: 1),
                        child: FadeInAnimation(
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("$baseUrl/images/movies/${state.slider[index].topPicksResponse[index].moviePoster}"),
                                    ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        return SizedBox(
          height: 150,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),

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
                          borderRadius: BorderRadius.circular(5),

                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }
}
