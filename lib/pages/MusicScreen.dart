import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mtott/Service/cubit/MusicCategoryCubit.dart';
import 'package:mtott/Service/cubit/MusicCategoryTypeCubit.dart';
import 'package:mtott/Service/cubit/RuningSongCubit.dart';
import 'package:mtott/Service/cubit/UpComingSongCubit.dart';
import 'package:mtott/Service/state/MusicCategoryState.dart';
import 'package:mtott/Service/state/UpComingSongState.dart';
import 'package:mtott/pages/MusicPlayerScreen.dart';
import 'package:shimmer/shimmer.dart';

import '../Service/admob/AdHelper.dart';
import '../Service/state/RunningSongState.dart';
import '../const.dart';

/*Upcoming Banners Api Using with Bloc State Management*/
/*Running Banners Api Using with Bloc State Management*/
/*Google Ads*/
/*Hollywood Music  Api Using with Bloc State Management*/
/*Chill Mode Api Using with Bloc State Management*/
class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<String> images = [
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
  ];
  int current = 0;
  CarouselController carouselController = CarouselController();
  PageController controller = PageController();
  int currentIndex = 0;
  List<String> recentImage = [
    "asset/image/marvel.png",
    "asset/image/designer.png",
    "asset/image/kalandar.png",
    "asset/image/marvel.png",
    "asset/image/kalandar.png",
  ];

  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            BlocConsumer<UpComingSongsCubit, UpComingSongState>(
                listener: (context, state) {
            }, builder: (context, state) {
              if (state is LoadedState) {
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
                                fit: BoxFit.fill,
                                image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                              )),
                        );
                      },
                      options: CarouselOptions(
                        height: 160,
                        autoPlay: true,

                        autoPlayCurve: Curves.easeInOutCubic,

                        autoPlayAnimationDuration: const Duration(seconds: 5),
                        viewportFraction:.80,
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

            BlocConsumer<RuningSongCubit, RuningSongState>(
                listener: (context, state) {

                },
                builder: (context, state) {
                if (state is LoadedStates) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                    child: CarouselSlider.builder(
                      itemCount: state.slider.length,
                      carouselController: carouselController,
                      itemBuilder: (context, index, _) {
                        currentIndex=index+1;
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("$baseUrl/${state.slider[index].data[index].image}"),
                              )),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Text("$currentIndex/${state.slider.length}"),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,

                        autoPlayCurve: Curves.easeInOutCubic,
                        autoPlayAnimationDuration: const Duration(seconds: 3),
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        onPageChanged: (int index, _) {},
                      ),
                    ));
              } else if (state is LoadingState) {
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

            /*AnimatedSmoothIndicator(
                activeIndex: current,
                effect: const WormEffect(
                  activeDotColor: Colors.amberAccent,
                  dotWidth: 10,
                  dotHeight: 10,
                  radius: 5,
                  dotColor: Colors.white,
                ),
                count: images.length),*/
            if (_bannerAd != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ),
            BlocBuilder<MusicCategoryCubit,MusicCategoryState>(
                builder: (context,state){
                  if(state is MusicCategoryLoadedState){
                    return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: state.slider.length,
                          shrinkWrap: true,
                          itemBuilder: (context, currentIndex) {
                            return Column(
                              children: <Widget>[
                                state.slider[currentIndex].musicResponse[currentIndex].musicData.isNotEmpty?InkWell(
                                  highlightColor:Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap:(){

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(index: 0,title: state.slider[0].musicResponse[currentIndex].musicData[currentIndex].musicType,url: "$baseUrl/${state.slider[0].musicResponse[currentIndex].musicData[currentIndex].music}", subtitle: state.slider[0].musicResponse[currentIndex].name, imgPath: '$baseUrl/${state.slider[0].musicResponse[currentIndex].musicData[currentIndex].musicCover}',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(state.slider[currentIndex].musicResponse[currentIndex].name),
                                        SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black),
                                      ],
                                    ),
                                  ),
                                ):Container(),

                                state.slider[currentIndex].musicResponse[currentIndex].musicData.isNotEmpty?SizedBox(
                                  height: 150,
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.slider[currentIndex].musicResponse[currentIndex].musicData.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            highlightColor:Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: (){
                                             setState(() {
                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(index: index,title: state.slider[index].musicResponse[currentIndex].musicData[index].musicType,url: "$baseUrl/${state.slider[index].musicResponse[currentIndex].musicData[index].music}", subtitle: state.slider[index].musicResponse[currentIndex].musicData[index].title, imgPath: '$baseUrl/${state.slider[index].musicResponse[currentIndex].musicData[index].musicCover}')));
                                               debugPrint('$baseUrl/${state.slider[index].musicResponse[currentIndex].musicData[index].musicCover} ${state.slider[currentIndex].musicResponse[currentIndex].musicData[index].title} ${state.slider[currentIndex].musicResponse[currentIndex].musicData[index].musicType} ${index}');
                                             });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                height: 100,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:NetworkImage("$baseUrl/${state.slider[index].musicResponse[currentIndex].musicData[index].musicCover}"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ):Container(),



                                /*BlocBuilder<MusicCategoryTypeCubit,MusicCategoryTypeState>(
                                    builder: (context,state){
                                      if(state is MusicCategoryTypeLoadedState){
                                        return SizedBox(
                                          height: 150,
                                          child: AnimationLimiter(
                                            child: ListView.builder(
                                                physics: const BouncingScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: state.slider.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(title: "Hollywood Music",url: "$baseUrl/${state.slider[index].data[index].music}", imgPath: "$baseUrl/${state.slider[index].data[index].musicCover}")));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: 100,
                                                        width: 140,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:NetworkImage("$baseUrl/${state.slider[index].data[index].musicCover}"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        );
                                      }
                                      return const Center(child: CircularProgressIndicator());
                                    }),*/
                              ],
                            );
                          });
                  }
                  return  Shimmer.fromColors(
                    baseColor: const Color(0xFFF7F8F8),
                    highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: state.props.length,
                        shrinkWrap: true,
                        itemBuilder: (context, currentIndex) {
                          return Column(
                            children: <Widget>[
                             Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(""),

                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 150,
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.props.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: 100,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF333945),
                                              borderRadius: BorderRadius.circular(10),

                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),



                              /*BlocBuilder<MusicCategoryTypeCubit,MusicCategoryTypeState>(
                                      builder: (context,state){
                                        if(state is MusicCategoryTypeLoadedState){
                                          return SizedBox(
                                            height: 150,
                                            child: AnimationLimiter(
                                              child: ListView.builder(
                                                  physics: const BouncingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: state.slider.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    return InkWell(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(title: "Hollywood Music",url: "$baseUrl/${state.slider[index].data[index].music}", imgPath: "$baseUrl/${state.slider[index].data[index].musicCover}")));
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          height: 100,
                                                          width: 140,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:NetworkImage("$baseUrl/${state.slider[index].data[index].musicCover}"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                        }
                                        return const Center(child: CircularProgressIndicator());
                                      }),*/
                            ],
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
    context.read<UpComingSongsCubit>().fetchSlider();
    context.read<RuningSongCubit>().fetchBannerSlider();
    setState(() {
      context.read<MusicCategoryCubit>().fetchMusicCategory();
    });

    super.initState();
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
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
  @override
  void didChangeDependencies() {
    context.read<UpComingSongsCubit>().fetchSlider();
    context.read<RuningSongCubit>().fetchBannerSlider();
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }
}
