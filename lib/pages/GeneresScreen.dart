import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/const.dart';
import 'package:shimmer/shimmer.dart';

import '../Service/cubit/GenresCubit.dart';
import '../Service/state/GenresState.dart';
import 'GenresCategoryScreen.dart';
import 'SearchScreen.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {

  @override
  void initState() {
    context.read<GenresCubit>().fetchGenres();
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
     
      appBar:  AppBar(

       
        leading: IconButton(

            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Genres"),
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
      body:BlocBuilder<GenresCubit,GenresState>(builder: (context,state){
        if(state is GenresLoadedState){
         return
           GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.slider.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.5),
              itemBuilder: (context,index){
                return AnimationLimiter(
                  
                  child: AnimationConfiguration.staggeredGrid(
                    
                    position: index,
                    columnCount: 2,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: (){
                        Navigator.push(context,PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => GenresCategoryScreen(id: state.slider[index].data[index].gid,title: state.slider[index].data[index].genreName),
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
                      child: ScaleAnimation(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOutSine,
                        delay: const Duration(seconds: 1),
                        child: FadeInAnimation(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage("$baseUrl/images/${state.slider[index].data[index].genreImage}"),
                                  )
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(state.slider[index].data[index].genreName,style: GoogleFonts.inter(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
        else if(state is GenresLoadingState){
          return Center(child: CircularProgressIndicator());
        }
        return  Shimmer.fromColors(
            baseColor: const Color(0xFFF7F8F8),
            highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
          child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount:5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.5),
              itemBuilder: (context,index){
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF333945),
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.cover,

                          image: AssetImage("asset/logo/logo.png"),
                        )
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(appName,style: GoogleFonts.inter(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
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
