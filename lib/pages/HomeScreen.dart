import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/cubit/GenresCubit.dart';
import 'package:mtott/Service/cubit/LatestChannelCubit.dart';
import 'package:mtott/Service/cubit/LatestMovieCubit.dart';
import 'package:mtott/Service/cubit/ShowsCubit.dart';
import 'package:mtott/Service/state/GenresState.dart';
import 'package:mtott/Service/state/LatestChannelState.dart';
import 'package:mtott/Service/state/LatestMoviesState.dart';
import 'package:mtott/Service/state/ShowsState.dart';
import 'package:mtott/const.dart';
import 'package:mtott/main.dart';
import 'package:mtott/pages/ChannelScreen.dart';
import 'package:mtott/pages/DetailsScreen.dart';

import 'package:mtott/pages/GenresCategoryScreen.dart';
import 'package:mtott/pages/LatestTrendingScreen.dart';
import 'package:mtott/pages/ShowScreen.dart';
import 'package:mtott/pages/TVSeriesScreen.dart';
import 'package:mtott/pages/TopPicksScreen.dart';
import 'package:mtott/plan/PlanScreen.dart';

import 'package:shimmer/shimmer.dart';
import '../Service/admob/AdHelper.dart';
import '../Service/cubit/RunningHomeSliderCubit.dart';
import '../Service/cubit/UpComingHomeSliderCubit.dart';
import '../Service/model/SettingModel.dart';
import '../Service/state/RuningHomeState.dart';
import '../Service/state/UpComingHomeSliderState.dart';
import 'GeneresScreen.dart';


/*Upcoming Banners Api Using with Bloc State Management*/
/*Running Banners Api Using with Bloc State Management*/
/*Google Ads*/
/*Channels Api Using with Bloc State Management*/
/*Latest Movies Api Using with Bloc State Management*/
/*Genres Api Using with Bloc State Management*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CarouselController carouselController=CarouselController();
  CarouselController carouselBannerController=CarouselController();

  int currentIndex=0;

  BannerAd? _bannerAd;
  List<SettingModel> settingModel=[];
  fetchSettings() async{
    final resp=await get(Uri.parse(privacy));
    final result=settingsmFromJson(resp.body);
    if(resp.statusCode==200){
      settingModel.clear();
      settingModel.add(SettingModel(status: result.status, message: result.message, data: result.data));
    }
    else{
      debugPrint("Error in Api ${resp.request!.url} and ${resp.statusCode}");
    }
  }


  @override
  void initState() {
    print("HomeScreen Upcoming Banner");
    context.read<UpComingHomeSliderCubit>().fetchSlider();
    context.read<RunningHomeSliderCubit>().fetchBannerSlider();
    context.read<LatestMovieCubit>().fetchLatestMovie();
    context.read<ShowsCubit>().fetchTVShows();
    context.read<LatestChannelCubit>().fetchLatestChannel();
    context.read<GenresCubit>().fetchGenres();

    /*context.read<LanguageCubit>().fetchLanguages();*/
    BannerAd(
      adUnitId:AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BlocBuilder<UpComingHomeSliderCubit,UpComingHomeSliderState>(
              builder: (context,state){
                if(state is LoadedState){
                 return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
                    child: CarouselSlider.builder(
                      carouselController: carouselBannerController,
                      itemCount: state.slider.length, itemBuilder: (context,index,_){
                      return Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                            )
                        ),

                      );
                    },  options: CarouselOptions(
                        height: 170,
                        autoPlay: true,
                        autoPlayCurve: Curves.easeInOutCubic,
                        autoPlayAnimationDuration: const Duration(seconds: 3),
                        viewportFraction:.79,


                        enlargeCenterPage: true,

                        onPageChanged: (int index,_){},
                    ),)
                  );
                }
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
                    child: CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: 5, itemBuilder: (context,index,_){
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFF7F8F8),
                        highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
                        child: Image.network("https://i.pinimg.com/originals/e1/e8/a1/e1e8a1dc7d61013adef34dd15b1c8a73.jpg"),
                      );
                    },  options: CarouselOptions(

                      height: 180,
                      autoPlay: true,

                      autoPlayCurve: Curves.easeInOutCubic,
                      autoPlayAnimationDuration: const Duration(seconds: 3),
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      onPageChanged: (int index,_){},
                    ),)
                );
              },
            ),
            BlocBuilder<RunningHomeSliderCubit,RuningHomeState>(

                builder: (context,state){
                if(state is LoadedStates){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:15.0),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,

                        autoPlayCurve: Curves.easeInOutCubic,
                        autoPlayAnimationDuration: const Duration(seconds: 5),
                        viewportFraction:.80,


                        onPageChanged: (int index,_){}
                    ),
                    itemCount: state.slider.length,
                    carouselController: carouselController,

                    itemBuilder: (context,index,_){
                      int currentIndex=index+1;
                      return Card(
                        margin: EdgeInsets.all(2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                              )
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
                              child: Text("$currentIndex/${state.slider.length}"),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
                else if(state is LoadingState){
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
                    child: CarouselSlider.builder(
                      carouselController: carouselBannerController,
                      itemCount: 5, itemBuilder: (context,index,_){
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFF7F8F8),
                        highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
                        child: Image.network("https://i.pinimg.com/originals/e1/e8/a1/e1e8a1dc7d61013adef34dd15b1c8a73.jpg"),
                      );
                    },  options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      aspectRatio: 16/9,
                      autoPlayCurve: Curves.easeInOutCubic,
                      autoPlayAnimationDuration: const Duration(seconds: 3),
                      viewportFraction: .7,
                      enlargeCenterPage: true,
                      onPageChanged: (int index,_){},
                    ),)
                );
            }),


            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                Navigator.push(context,PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) =>  const LatestTrendingScreen(),

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
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Latest & Trending"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                ]),
              ),
            ),


            BlocBuilder<LatestMovieCubit,LatestMovieState>(

                builder: (context,state){
                  if(state is LatestMovieLoadedState){
                   return SizedBox(
                     height: 250,
                     child: AnimationLimiter(

                       child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.slider.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),

                            itemBuilder: (context,index){
                              return AnimationConfiguration.staggeredList(

                                position: index,
                                duration: const Duration(seconds: 1),
                                child: SlideAnimation(
                                  horizontalOffset: 200,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInSine,
                                  delay: const Duration(seconds: 1),
                                  child: FadeInAnimation(

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
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: 400,
                                          width: 200,
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
                            }),
                     ),
                   );
                  }
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                        }),
                  );
                }),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                Navigator.push(context,PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) =>  ShowsScreen(),
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
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Shows"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),

                    ]),
              ),
            ),
            BlocBuilder<ShowsCubit,ShowsState>(builder: (context,state){
              if(state is ShowsLoadedState){
                return SizedBox(

                  height: 250,
                  child: AnimationLimiter(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.slider.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),

                        itemBuilder: (context,index){
                          return AnimationConfiguration.staggeredList(
                            position: index,

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
                              child: ScaleAnimation(
                                scale: 0.5,

                                duration: const Duration(seconds: 5),
                                curve: Curves.easeInOutSine,
                                delay: const Duration(seconds: 1),
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(

                                      height: 400,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius:  BorderRadius.circular(12),
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
                        }),
                  ),
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
                                borderRadius:  BorderRadius.circular(12),

                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),


            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (){
                Navigator.push(context,PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Channels"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                    ]),
              ),
            ),
            BlocBuilder<LatestChannelCubit,LatestChannelState>(builder:(context,state){
              if(state is LatestChannelLoadedState){
                return SizedBox(
                  height: 150,
                  child: AnimationLimiter(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.slider.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          return AnimationConfiguration.staggeredList(
                            position: index,

                            duration: const Duration(seconds: 5),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {


                                  Navigator.push(context, PageRouteBuilder(
                                    transitionDuration: const Duration(
                                        seconds: 1),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                        DetailsScreen(
                                          id: state.slider[index]
                                              .data[index].cid,
                                          url: state.slider[index]
                                              .data[index].channelUrl,
                                          title: state.slider[index]
                                              .data[index].channelTitle,
                                          description: state.slider[index]
                                              .data[index].channelDesc,
                                          type: state.slider[index]
                                              .data[index].channelType,
                                          imgPath: "$baseUrl/images/${state
                                              .slider[index].data[index]
                                              .channelThumbnail}",
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
                              child: ScaleAnimation(
                                scale: .6,
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeInOutSine,
                                delay: const Duration(seconds: 1),
                                child: FadeInAnimation(
                                  child: Card(
                                    margin: const EdgeInsets.all(2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage("$baseUrl/images/${state.slider[index].data[index].channelThumbnail}")),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
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
                                borderRadius:  BorderRadius.circular(12),

                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
          /* Genres start*/
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,

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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Genres"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),

                    ]),
              ),
            ),
            BlocBuilder<GenresCubit,GenresState>(builder: (context,state){
              if(state is GenresLoadedState){
                return SizedBox(
                    height: 150,
                    child: AnimationLimiter(

                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.slider.length,
                          itemBuilder: (context,index){
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(seconds: 5),
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
                                child: SlideAnimation(
                                  horizontalOffset: 500,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInOutSine,
                                  delay: const Duration(seconds: 1),
                                  child: FadeInAnimation(
                                    child: Card(
                                      margin: EdgeInsets.all(2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage("$baseUrl/images/${state.slider[index].data[index].genreImage}"),
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom:20.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                                              child: Text(state.slider[index].data[index].genreName,style: GoogleFonts.inter(color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
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

            /* Genres end*/

            /* Language start*/
            /*InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                Navigator.push(context,PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) =>  const LanguageScreen(),
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
                padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Language"),

                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                    ]),
              ),
            ),
            BlocBuilder<LanguageCubit,LanguageState>(builder: (context,state){
             if(state is LanguageLoadedState){
               return SizedBox(
                 height: 150,
                 child: AnimationLimiter(
                   child: ListView.builder(
                       shrinkWrap: true,
                       physics: const BouncingScrollPhysics(),
                       itemCount: state.slider.length,
                       scrollDirection: Axis.horizontal,
                       itemBuilder: (context,index){
                         return AnimationConfiguration.staggeredList(
                           position: index,
                           duration: const Duration(seconds: 6),
                           child: SlideAnimation(
                             curve: Curves.easeInOutSine,
                             child: FadeInAnimation(
                               child: InkWell(
                                 highlightColor: Colors.transparent,
                                 splashColor: Colors.transparent,
                                 onTap: (){
                                   Navigator.push(context,PageRouteBuilder(
                                     transitionDuration: const Duration(seconds: 1),
                                     pageBuilder: (context, animation, secondaryAnimation) =>  ViewScreen(title: state.slider[index].data[index].languageName, url: '',),
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
                                 child: Card(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   child: Container(
                                     width: 200,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),

                                       image: DecorationImage(
                                           fit: BoxFit.cover,
                                           image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}")),
                                     ),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       children: [
                                         Text(state.slider[index].data[index].languageName,style: GoogleFonts.inter(color: Colors.white)),
                                         Text(state.slider[index].data[index].languageName,style: GoogleFonts.inter(color: Colors.white)),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         );
                       }),
                 ),
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
            })*/

            /* Language end*/

          ],
        ),
      ),
    );
  }
}
