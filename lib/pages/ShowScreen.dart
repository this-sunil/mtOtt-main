import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtott/pages/SearchScreen.dart';
import 'package:mtott/pages/TVSeriesScreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Service/cubit/ShowsCubit.dart';
import '../Service/state/ShowsState.dart';
import '../const.dart';
import 'DetailsScreen.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({Key? key}) : super(key: key);

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Shows"),
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
      body: BlocBuilder<ShowsCubit,ShowsState>(builder: (context,state){
        if(state is ShowsLoadedState){
          return AnimationLimiter(
            child: GridView.builder(

                itemCount: state.slider.length,

                physics: BouncingScrollPhysics(),

                itemBuilder: (context,index){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(seconds: 2),
                    child: SlideAnimation(
                      curve: Curves.easeInOutSine,
                      child: FadeInAnimation(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: (){
                            Navigator.push(context,PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (context, animation, secondaryAnimation) =>  TvSeriesScreen(id: state.slider[index].data[index].id,title: state.slider[index].data[index].seriesName,description: state.slider[index].data[index].seriesDesc,imgPath: '$baseUrl/images/series/${state.slider[index].data[index].seriesCover}', seasonId: state.slider[index].data[index].seasonData[0].id),
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
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                            /*  height: 400,
                              width: 200,*/
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("$baseUrl/images/series/${state.slider[index].data[index].seriesCover}"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }, gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.0)),
          );
        }
        return SizedBox(
          height: 250,
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
