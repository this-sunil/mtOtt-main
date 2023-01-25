import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mtott/Service/cubit/RuningWebSeriesCubit.dart';
import 'package:mtott/Service/cubit/UpComingSeriesCubit.dart';
import 'package:mtott/Service/state/RuningWebSeriesState.dart';
import 'package:mtott/Service/state/UpComingSeriesState.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/TopPicksScreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Service/admob/AdHelper.dart';
import '../Service/cubit/ShowsCubit.dart';
import '../Service/cubit/TopPicksCubit.dart';
import '../Service/state/ShowsState.dart';
import '../Service/state/TopPicksState.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import 'DetailsScreen.dart';
import 'ShowScreen.dart';
import 'TVSeriesScreen.dart';
/*Upcoming Banners Api Using with Bloc State Management*/
/*Running Banners Api Using with Bloc State Management*/
/*Google Ads*/
/*Top picks Api Using with Bloc State Management*/
/*Shows Api Using with Bloc State Management*/
class WebSeriesScreen extends StatefulWidget {
  const WebSeriesScreen({Key? key}) : super(key: key);

  @override
  State<WebSeriesScreen> createState() => _WebSeriesScreenState();
}

class _WebSeriesScreenState extends State<WebSeriesScreen> {

  List<String> images=[
    "asset/image/slides.png",
    "asset/image/slides.png",
    "asset/image/slides.png",
    "asset/image/slides.png",
    "asset/image/slides.png",
  ];
  CarouselController carouselController=CarouselController();
  int currentIndex=0;

  BannerAd? _bannerAd;



  @override
  void initState() {
    context.read<UpComingSeriesSliderCubit>().fetchSlider();
    context.read<RunningWebSeriesCubit>().fetchSlider();
    context.read<ShowsCubit>().fetchTVShows();
    context.read<TopPicksCubit>().fetchTopPicks();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
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
  void didChangeDependencies() {
    context.read<UpComingSeriesSliderCubit>().fetchSlider();
    context.read<RunningWebSeriesCubit>().fetchSlider();
    super.didChangeDependencies();
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
            BlocBuilder<UpComingSeriesSliderCubit,UpComingSeriesState>(

                builder: (context,state){
              if(state is loadedState){
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                    child: CarouselSlider.builder(
                      itemCount: state.slider.length,
                      carouselController: carouselController,
                      itemBuilder: (context, index, _) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                              )),
                        );
                      },
                      options: CarouselOptions(
                        height: 160,
                        autoPlay: true,

                        viewportFraction: .85,
                        autoPlayCurve: Curves.easeInOutCubic,
                        autoPlayAnimationDuration: const Duration(seconds: 3),
                        enlargeCenterPage: true,
                        onPageChanged: (int index, _) {},
                      ),
                    ));
              }
              else if (state is loadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return  Padding(
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

            BlocBuilder<RunningWebSeriesCubit,RunningWebSeriesState>(

                builder: (context,state){
                  debugPrint("WebSeries Running ${state.props.length}");
                if(state is LoadedStates){
                  return  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          height: 200,
                          autoPlay: true,

                          autoPlayCurve: Curves.easeInOutCubic,
                          autoPlayAnimationDuration: const Duration(seconds: 5),
                          viewportFraction:.80,

                          onPageChanged: (int index, _) {}),
                      itemCount: state.slider.length,
                      carouselController: carouselController,
                      itemBuilder: (context, index, _) {
                        int currentIndex = index + 1;
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                                )),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Text("$currentIndex/${state.slider.length}"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else if (state is loadingState) {
                  return const Center(child: CircularProgressIndicator());
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
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) =>  TopPicksScreen(),
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
                      Text("Top Picks for you"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                    ]),
              ),
            ),

            BlocBuilder<TopPicksCubit,TopPicksState>(builder: (context,state){
              if(state is TopPicksLoadedState){
                return SizedBox(
                  height: 250,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.slider.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsScreen(id: state.slider[index]
                                          .topPicksResponse[index].id,
                                          url: state.slider[index]
                                              .topPicksResponse[index].movieUrl,
                                          title: state.slider[index]
                                              .topPicksResponse[index]
                                              .movieTitle,
                                          description: state.slider[index]
                                              .topPicksResponse[index]
                                              .movieDesc,
                                          type: state.slider[index]
                                              .topPicksResponse[index]
                                              .movieType,
                                          imgPath: "$baseUrl/images/movies/${state
                                              .slider[index]
                                              .topPicksResponse[index]
                                              .moviePoster}",
                                          seriesId: '',
                                          mType: 'series')));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(

                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("$baseUrl/images/movies/${state.slider[index].topPicksResponse[index].moviePoster}"),
                                ),
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
                            padding: const EdgeInsets.all(4.0),
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
                      Text("Shows"),
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
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(seconds: 2),
                            child: ScaleAnimation(
                              curve: Curves.easeInOutSine,
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
                                    height: 400,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("$baseUrl/images/series/${state.slider[index].data[index].seriesCover}"),
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
                            padding: const EdgeInsets.all(4.0),
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

          ],
        ),
      ),
    );
  }
}
