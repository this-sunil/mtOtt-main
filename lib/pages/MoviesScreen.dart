import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtott/Service/cubit/RunningMovieCubit.dart';
import 'package:mtott/Service/cubit/TopPicksCubit.dart';
import 'package:mtott/Service/state/RuningMovieState.dart';
import 'package:mtott/Service/state/TopPicksState.dart';
import 'package:mtott/pages/TopPicksScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Service/admob/AdHelper.dart';
import '../Service/cubit/UpComingMovieSliderCubit.dart';
import '../Service/state/MovieSliderState.dart';
import '../const.dart';
import 'DetailsScreen.dart';


/*Upcoming Banners Api Using with Bloc State Management*/
/*Running Banners Api Using with Bloc State Management*/
/*Google Ads*/
/*Top picks Api Using with Bloc State Management*/

class MoviesScreen extends StatefulWidget {
  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<String> images = [
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
  ];

  var response = "";

  CarouselController carouselController = CarouselController();
  CarouselController carouselBannerController = CarouselController();
  int currentIndex = 0;
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BlocBuilder<UpComingMovieSliderCubit, MovieSliderState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                      child: CarouselSlider.builder(
                        itemCount: state.slider.length,
                        carouselController: carouselBannerController,
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
                          autoPlayCurve: Curves.easeInOutCubic,
                          autoPlayAnimationDuration: const Duration(seconds: 5),
                          autoPlay: true,
                          viewportFraction: .85,
                          enlargeCenterPage: true,
                          onPageChanged: (int index, _) {},
                        ),
                      ));
                }
                else if (state is LoadingState) {
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
              },
            ),
            BlocBuilder<RuningMovieSliderCubit,RuningMovieState>(
              builder: (context,state){
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
              else if (state is LoadingState) {
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
            },

            ),


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
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (){
                Navigator.push(context,PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) =>  const TopPicksScreen(),

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
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top Picks for you"),
                      SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)
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
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(id: state.slider[index].topPicksResponse[index].id,url: state.slider[index].topPicksResponse[index].movieUrl, title: state.slider[index].topPicksResponse[index].movieTitle, description: state.slider[index].topPicksResponse[index].movieDesc, type: state.slider[index].topPicksResponse[index].movieType, imgPath: "$baseUrl/images/movies/${state.slider[index].topPicksResponse[index].moviePoster}", seriesId: '', mType: 'movie',)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(

                              width: 180,
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

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    print("Movies Screen Upcoming Banner");
    context.read<UpComingMovieSliderCubit>().fetchSlider();
    context.read<RuningMovieSliderCubit>().fetchSlider();
    context.read<TopPicksCubit>().fetchTopPicks();

    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
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
  }
  @override
  void didChangeDependencies() {
    context.read<UpComingMovieSliderCubit>().fetchSlider();
    context.read<RuningMovieSliderCubit>().fetchSlider();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }
}
