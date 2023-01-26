import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtott/Service/cubit/GenresCategoryCubit.dart';
import 'package:mtott/Service/state/GenresCategoryState.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/DetailsScreen.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import 'SearchScreen.dart';

class GenresCategoryScreen extends StatefulWidget {
  final String title;
  final String id;
  const GenresCategoryScreen({Key? key,required this.title,required this.id}) : super(key: key);
  @override
  State<GenresCategoryScreen> createState() => _GenresCategoryScreenState();
}

class _GenresCategoryScreenState extends State<GenresCategoryScreen> {
  @override
  void initState() {
    debugPrint("Genres ID ${widget.id}");
    setState(() {
      context.read<GenresCategoryCubit>().fetchGenres(widget.id);
    });
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
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",
            color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),


        title: Text(widget.title),
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
      body: RefreshIndicator(
        onRefresh: () async{
          context.read<GenresCategoryCubit>().fetchGenres(widget.id);
        },
        child: BlocBuilder<GenresCategoryCubit,GenresCategoryState>(
          builder: (context,state){
            if(state is LoadedState){
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: .8),
                  itemCount: state.slider.length,
                  itemBuilder: (context,index){
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
                        else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(
                                    id: state.slider[index].data[index].id
                                        .toString(),
                                    url: "${state.slider[index].data[index]
                                        .movieUrl}",
                                    title: "${state.slider[index].data[index]
                                        .movieTitle}",
                                    description: "${state.slider[index]
                                        .data[index].movieDesc}",
                                    type: "${state.slider[index].data[index]
                                        .movieType}",
                                    imgPath: "$baseUrl/images/movies/${state
                                        .slider[index].data[index].movieCover}",
                                    seriesId: "",
                                    mType: '',)));
                        }
                      },
                      child: Hero(
                        tag: widget.id,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network("$baseUrl/images/movies/${state.slider[index].data[index].movieCover}",fit: BoxFit.cover)),
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
