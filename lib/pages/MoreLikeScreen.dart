import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Service/cubit/MoreLikeCubit.dart';
import '../Service/state/MoreLikeState.dart';
import '../const.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import 'DetailsScreen.dart';
import 'SearchScreen.dart';

class MoreLikeScreen extends StatefulWidget {
  const MoreLikeScreen({Key? key}) : super(key: key);

  @override
  State<MoreLikeScreen> createState() => _MoreLikeScreenState();
}

class _MoreLikeScreenState extends State<MoreLikeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: const Text("More Like"),
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
      body: BlocBuilder<MoreLikeCubit,MoreLikeState>(builder: (context,state){
        if(state is LoadedState){
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

              itemCount: state.slider.length,
              physics: const BouncingScrollPhysics(),

              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
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
                    else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(id: state.slider[index].data[index].id, url: state.slider[index].data[index].movieUrl, title: state.slider[index].data[index].movieTitle, description: state.slider[index].data[index].movieDesc, type: state.slider[index].data[index].movieType, imgPath: "$baseUrl/images/movies/${state.slider[index].data[index].movieCover}", seriesId: '', mType: 'movie',)));
                    }
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("$baseUrl/images/movies/${state.slider[index].data[index].movieCover}"),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
