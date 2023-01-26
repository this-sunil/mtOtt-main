import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtott/const.dart';
import 'package:mtott/utility/theme/Database.dart';

import '../Service/cubit/MusicCategoryTypeCubit.dart';
import '../Service/model/Music.dart';
import '../main.dart';
import 'MusicPlayerScreen.dart';
import 'SearchScreen.dart';

class FavouriteMusicScreen extends StatefulWidget {
  const FavouriteMusicScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteMusicScreen> createState() => _FavouriteMusicScreenState();
}

class _FavouriteMusicScreenState extends State<FavouriteMusicScreen> {
  DatabaseHelper helper=DatabaseHelper();
  HashSet selectItem=HashSet();
  multipleSelection(String title) async{
    if(selectItem.contains(title)){
      selectItem.remove(title);
    }
    else{
      selectItem.add(title);
    }
    setState(() {

    });
  }
  @override
  void initState() {
    helper.init();
    helper.fetchFav().then((value){
      debugPrint("Success");
    });
    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: const Text("Favourite"),
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black))
        ],
      ),
      body:
      RefreshIndicator(
        onRefresh: () async{
          helper.fetchFav();
        },
        child: FutureBuilder<List<Music>>(
          future: helper.fetchFav(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          horizontalOffset: 1000,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOutSine,
                          delay: const Duration(seconds: 1),
                          child: FadeInAnimation(
                            child: Card(

                              child: ListTile(
                                leading: CircleAvatar(
                                    maxRadius: 25,
                                    backgroundImage: NetworkImage("$baseUrl/${snapshot.data![index].image}")),
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(snapshot.data![index].subtitle),
                                trailing: IconButton(onPressed: selectItem.contains(snapshot.data![index].title)?(){
                                  helper.removeFav(snapshot.data![index].title);
                                  selectFav.remove(snapshot.data![index].title);
                                  setState(() {
                                    helper.init();
                                  });
                                }:(){},icon:selectItem.contains(snapshot.data![index].title)?const Icon(Icons.delete):Container()),
                                onLongPress: (){
                                  multipleSelection(snapshot.data![index].title);
                                },
                                onTap: (){
                                  setState(() {
                                    context.read<MusicCategoryTypeCubit>().fetchMusicCategoryType(snapshot.data![index].subtitle);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(index:int.parse(snapshot.data![index].index),title: snapshot.data![index].subtitle,url: "$baseUrl/${snapshot.data![index].url}", subtitle: snapshot.data![index].title, imgPath: snapshot.data![index].image)));
                                  });


                                },
                              ),
                            ),
                          ),
                        ),
                      );

                }),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
