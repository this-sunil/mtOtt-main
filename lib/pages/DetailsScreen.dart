import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/cubit/SeasonCubit.dart';
import 'package:html/parser.dart' as html;
import 'package:mtott/Service/model/LanguageSourceModel.dart';
import 'package:mtott/Service/state/MoreLikeState.dart';
import 'package:mtott/Service/state/SeasonState.dart';
import 'package:mtott/Service/state/SeriesState.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:pod_player/pod_player.dart';
import 'package:share_plus_dialog/share_plus_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Service/admob/AdHelper.dart';
import '../Service/cubit/MoreLikeCubit.dart';
import '../Service/cubit/SeriesCubit.dart';
import '../const.dart';
import '../main.dart';
import '../plan/PlanScreen.dart';
import '../utility/theme/Database.dart';
import 'DownloadTask.dart';
import 'MoreLikeScreen.dart';

import 'package:path_provider/path_provider.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String url;
  final String title;
  final String description;
  final String? seasonId;
  final String type;
  final String mType;

  final String imgPath;
  final String seriesId;
  const DetailsScreen(
      {Key? key,
      required this.id,
      required this.url,
      required this.title,
      required this.description,
      this.seasonId,
      required this.type,
      required this.imgPath,
      required this.seriesId,
      required this.mType})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late PodPlayerController podPlayerController;

  /*late FlickManager flickManager;*/

  /* late PodPlayerController controller;*/
  //late TabController tabController;
  /* late VideoPlayerController controller;*/
  String qualityTitle = "Auto";
  bool volumeOn = false;
  double currentValue = 0.0;
  bool isSelected = false;
  HashSet<String> selectItem = HashSet<String>();
  bool ad_called = false;

  InterstitialAd? _interstitialAd;

  multipleSelect(String title) {
    if (selectItem.length == 2) {
      selectItem.remove(title);
    } else {
      selectItem.clear();
      selectItem.add(title);
      qualityTitle = selectItem.first;
    }
    setState(() {});
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  final String url =
      'https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110_250.m3u8';
  List<String> images = [
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
    "asset/image/slide.png",
  ];
  List<String> season = [
    "Season 1",
    "Season 2",
    "Season 3",
    "Season 4",
    "Season 5",
  ];
  HashSet<String> selectChip = HashSet();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool flag = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late YoutubePlayerController youtubePlayer;
  String videoId = "";
  String vimeoId = "";

  late SharedPreferences pref;
  /*View Api Call in the fetchData method*/
  fetchData() async {
    if (widget.seriesId.isNotEmpty) {
      BlocProvider.of<SeriesCubit>(context).fetchTVSeries(widget.seriesId);
      context
          .read<SeasonCubit>()
          .fetchTVSeason(widget.seriesId, widget.seasonId.toString());

      setState(() {
        flag = true;
      });
    }

    /* SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      length=pref.getInt("series");
      //tabController = TabController(length:length, vsync: this);
    });*/

    /* Views Api Call */
    if (views.contains(widget.title)) {
      debugPrint("Alredy Views");
    } else {
      final resp =
          await post(Uri.parse(viewsApi), body: {"series_id": widget.seriesId});
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        debugPrint("${result["message"]}");
        views.add(widget.title);
      }
      debugPrint("Season Length ${views.length}");
    }
  }

  List<LanguageSourceModel> langaugeSourceData = [];
  fetchLanguageSource() async {
    final resp = await post(Uri.parse(languageSource),
        body: {"movie_title": widget.title});
    final result = languageSourceModelFromJson(resp.body);
    if (resp.statusCode == 200) {
      langaugeSourceData.clear();
      if (result.data.isNotEmpty) {
        for (int i = 0; i < result.data.length; i++) {
          langaugeSourceData.add(LanguageSourceModel(
              status: result.status,
              message: result.message,
              data: result.data));
        }
      }
    } else {
      debugPrint("Error in Api ${resp.request!.url} and ${resp.body}");
    }
    setState(() {});
  }

  shareDetails() async {
    return ShareDialog.share(context, widget.imgPath,
        platforms: [
          SharePlatform.whatsapp,
          SharePlatform.email,
          SharePlatform.telegram
        ],
        isUrl: false,
        subject: widget.title);
  }

  selectLanguageSource(String title) {
    if (selectChip.contains(title)) {
      selectChip.remove(title);
    } else {
      selectChip.clear();
      selectChip.add(title);
    }
    setState(() {});
  }

  DatabaseHelper helper = DatabaseHelper();
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }



  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    FlutterDownloader.registerCallback(downloadCallback);
    helper.init();

    fetchData();
    fetchLanguageSource();
    debugPrint("Video Url ${widget.url}");
    print(videoId); // BBAyRBTfsOU
    if (widget.type == "youtube_url" || widget.type == "youtube") {
      if (widget.url.isNotEmpty) {
        videoId = YoutubePlayer.convertUrlToId(widget.url).toString();
        youtubePlayer = YoutubePlayerController(initialVideoId: videoId);
      }
    } else if (widget.type == "vimeo_url") {
      vimeoId = widget.url;
    } else {}
    debugPrint("Widget Url ${widget.type}");

    podPlayerController = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
          videoQualityPriority: [1080, 720, 360],
          wakelockEnabled: false,
        ),
        playVideoFrom: widget.type == "youtube_url" || widget.type == "youtube"
            ? PlayVideoFrom.youtube(videoId)
            : widget.type == "vimeo_url"
                ? PlayVideoFrom.vimeo(vimeoId)
                : PlayVideoFrom.network(
                    "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
                    formatHint: VideoFormat.hls))
      ..initialise();
    debugPrint("Movie Id ${widget.id}");

    context.read<MoreLikeCubit>().fetchMoreLike(widget.id);

    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      _loadInterstitialAd();
    });
  }

  @override
  void dispose() {
    podPlayerController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  showVideoQuality() async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                color: Color(0XFF1B1F20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text("Select Video Quality"),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        qualityTitle = "Auto";
                        multipleSelect(qualityTitle);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text("Auto",
                                style: GoogleFonts.inter(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                          qualityTitle = "1080";
                          multipleSelect(qualityTitle);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text("Full HD upto 1080p",
                                style: GoogleFonts.inter(color: Colors.white)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                    child: Text("SUBSCRIBE",
                                        style:
                                            TextStyle(color: Colors.yellow))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                          qualityTitle = "720";
                          multipleSelect(qualityTitle);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text("Full HD upto 720p",
                                style: GoogleFonts.inter(color: Colors.white)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                    child: Text("SUBSCRIBE",
                                        style:
                                            TextStyle(color: Colors.yellow))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                          qualityTitle = "480";
                          multipleSelect(qualityTitle);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text("SD upto 480p",
                                style: GoogleFonts.inter(color: Colors.white)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                    child: Text("SUBSCRIBE",
                                        style:
                                            TextStyle(color: Colors.yellow))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  settingBottomSheet() {
    return scaffoldKey.currentState?.showBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30))), (context) {
      return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        color: Color(0xFF1B1F20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset("asset/logo/settings.svg",
                        width: 15, height: 15),
                    Text("Settings",
                        style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Row(children: [
                      Text("Subtitle",
                          style: GoogleFonts.inter(color: Colors.white)),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "English",
                            style: GoogleFonts.inter(color: Colors.white60),
                          ),
                        ),
                      ),
                    ])),
                    const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showVideoQuality();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Row(
                      children: [
                        Text("Video Quality",
                            style: GoogleFonts.inter(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text("$qualityTitle",
                              style: GoogleFonts.inter(color: Colors.white60)),
                        )
                      ],
                    )),
                    const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text("Report an issue",
                          style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  double volume = 0.0;
  addtoWatchList(String musicType, String movieName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String userId = pref.getString("uid").toString();
    final res = await post(Uri.parse(watchList), body: {
      "userid": userId,
      "type": musicType,
      "watch": widget.id,
    });
    final result = jsonDecode(res.body);
    if (res.statusCode == 200) {
      debugPrint(result["message"]);
      final banner = AwesomeSnackbarContent(
          title: 'Success',
          message: result["message"],
          contentType: ContentType.success,
          inMaterialBanner: true);
      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showSnackBar(
            SnackBar(content: banner, backgroundColor: Colors.transparent));
      debugPrint(res.body);
    } else {
      debugPrint("Error in Api ${res.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_interstitialAd != null && !ad_called) {
      setState(() {
        ad_called = true;
      });
      _interstitialAd?.show();
    }

    return Scaffold(
      key: scaffoldKey,

      body: SafeArea(
        child: CustomScrollView(

          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              systemOverlayStyle:const SystemUiOverlayStyle(),
                expandedHeight: 250,
                floating: true,
                elevation: 10,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset("asset/logo/leftarrow.svg",
                        color: Colors.white)),
                title: Text(capitalize(widget.title),
                    style:
                        GoogleFonts.inter(color: Colors.white, fontSize: 20)),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  collapseMode: CollapseMode.parallax,
                  background: Stack(fit: StackFit.expand, children: [
                    PodVideoPlayer(
                      controller: podPlayerController,
                      backgroundColor: Colors.transparent,
                      alwaysShowProgressBar: false,
                      matchFrameAspectRatioToVideo: true,
                      matchVideoAspectRatioToFrame: true,
                      podPlayerLabels:
                          const PodPlayerLabels(settings: "Settings"),
                      podProgressBarConfig: const PodProgressBarConfig(
                          circleHandlerColor: Colors.white,
                          playingBarColor: Colors.green,
                          circleHandlerRadius: 5,
                          padding: EdgeInsets.only(bottom: 5)),
                      onVideoError: () {
                        return IconButton(
                            onPressed: () {}, icon: const Icon(Icons.info));
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 40,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if (volume == 1.0) {
                                PerfectVolumeControl.setVolume(1.0);
                              } else {
                                PerfectVolumeControl.setVolume(volume);
                                volume += 0.1;
                              }
                              debugPrint(volume.toString());
                            },
                            icon: const Icon(Icons.volume_up)),
                      ),
                    ),
                  ]),
                )),
            SliverToBoxAdapter(
              child: langaugeSourceData.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          children: langaugeSourceData.first.data.map((e) {
                        return InkWell(
                          onTap: () {
                            print(e.languageName);
                            selectLanguageSource(e.languageName);
                            if (e.movieType == "youtube_url") {
                              podPlayerController.changeVideo(
                                  playVideoFrom:
                                      PlayVideoFrom.youtube(e.movieUrl));
                            } else {
                              podPlayerController.changeVideo(
                                  playVideoFrom:
                                      PlayVideoFrom.vimeo(e.movieUrl));
                            }
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: selectChip.contains(e.languageName)
                                ? Colors.deepPurple
                                : Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(e.languageName,style: GoogleFonts.inter(color: Colors.white)),
                            ),
                          ),
                        );
                      }).toList()),
                    )
                  : const SizedBox(height: 10),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.imgPath,
                              ),
                            )),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(widget.title, textAlign: TextAlign.left),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                  html.parse(widget.description).body!.text,
                                  textAlign: TextAlign.justify),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.mType == ""
                ? const SliverToBoxAdapter(
                    child: SizedBox(height: 5),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                elevation: MaterialStateProperty.all(10),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15)),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Color(0xFF1B1F20)
                                        : Colors.black),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Color(0xFF1B1F20)))),
                            onPressed: () async {
                              /* var tempDir = await getTemporaryDirectory();
                          String fullPath = "${tempDir.path}/${widget.title}.mp4";*/

                              helper.addDownload(
                                  widget.id,
                                  widget.title,
                                  widget.url,
                                  widget.description,
                                  "${widget.seasonId}",
                                  widget.imgPath,
                                  widget.type,
                                  widget.seriesId);
                              Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                pageBuilder: (context, animation, secondaryAnimation) =>  MyDownload(platform: Theme.of(context).platform),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset("asset/logo/download.svg"),
                                SizedBox(width: 10),
                                Text("Download",
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                              ],
                            )),
                        OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              elevation: MaterialStateProperty.all(10),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15)),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Color(0xFF1B1F20)
                                      : Colors.black),
                              side: MaterialStateProperty.all(
                                  BorderSide(color: Color(0xFF1B1F20))),
                            ),
                            onPressed: () {
                              print("${widget.mType} And ${widget.id}");
                              addtoWatchList(widget.mType,widget.title);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text("Watchlist",
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                              ],
                            )),
                        OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                elevation: MaterialStateProperty.all(10),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15)),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Color(0xFF1B1F20)
                                        : Colors.black),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Color(0xFF1B1F20)))),
                            onPressed: () {
                              shareDetails();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset("asset/logo/share.svg",
                                    width: 10, height: 10),
                                const SizedBox(width: 10),
                                Text("Share",
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                              ],
                            ))
                      ],
                    ),
                  )),
            SliverToBoxAdapter(
              child: flag == false
                  ? Container()
                  : BlocBuilder<SeriesCubit, SeriesState>(
                      builder: (context, state) {
                      if (state is SeriesLoadedState) {
                        return DefaultTabController(
                          length: state.slider.length,
                          child: SizedBox(
                              height: 40,
                              child: TabBar(
                                labelPadding: EdgeInsets.all(5),
                                labelColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                physics: const BouncingScrollPhysics(),
                                onTap: (int index) {
                                  print("Index $index");
                                  debugPrint(
                                      "Series Id ${state.slider[0].data[index].seriesId} and Season ID ${state.slider[0].data[index].id}");
                                  BlocProvider.of<SeasonCubit>(context)
                                      .fetchTVSeason(
                                          state.slider[0].data[index].seriesId,
                                          state.slider[0].data[index].id);
                                },
                                isScrollable: true,
                                indicatorColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                tabs: state.slider[0].data.map((e) {
                                  return Text("${e.seasonName}");
                                }).toList(),
                              )),
                        );
                      }
                      return Container();
                    }),
            ),
            SliverToBoxAdapter(
              child: flag == false
                  ? Container()
                  : BlocBuilder<SeasonCubit, SeasonState>(
                      builder: (context, state) {
                      if (state is SeasonLoadedState) {
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.slider.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                        const Duration(seconds: 1),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                            DetailsScreen(
                                              id: state.slider[index]
                                                  .data[index].id,
                                              url: state.slider[index]
                                                  .data[index]
                                                  .episodeUrl,
                                              title: state.slider[index]
                                                  .data[index]
                                                  .episodeTitle,
                                              description: state
                                                  .slider[index].data[index]
                                                  .subtitle,
                                              type: state.slider[index]
                                                  .data[index]
                                                  .episodeType,
                                              imgPath:
                                              '$baseUrl/images/episodes/${state
                                                  .slider[index].data[index]
                                                  .episodePoster}',
                                              seriesId: state
                                                  .slider[index].data[index]
                                                  .seriesId,
                                              seasonId: state
                                                  .slider[index].data[index]
                                                  .seasonId,
                                              mType: 'webseries',
                                            ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(
                                              begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ));

                              },
                              child: Card(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF333945)
                                      : Colors.white60,
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Container(
                                          width: 220,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    topLeft:
                                                        Radius.circular(5)),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}"),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          "asset/logo/play.svg",
                                                          width: 20,
                                                          height: 20),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                              state
                                                                  .slider[index]
                                                                  .data[index]
                                                                  .episodeTitle,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                      color: Colors
                                                                          .white)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 220,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                                state.slider[index].data[index]
                                                    .episodeTitle,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 8),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            backgroundColor:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? const Color(0xFF333945)
                                                        .withOpacity(.5)
                                                    : Colors.white60,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                    "asset/logo/download.svg",
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              Text("Download",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ],
                                          ),
                                          onPressed: () async {
                                            helper.addDownload( state.slider[index].data[index].id,  state.slider[index].data[index].episodeTitle,  state.slider[index].data[index].episodeUrl,  '',  state.slider[index].data[index].seasonId, "$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}",  state.slider[index].data[index].seriesId,  state.slider[index].data[index].episodeType);
                                            Navigator.push(context, PageRouteBuilder(
                                              transitionDuration: const Duration(seconds: 1),
                                              pageBuilder: (context, animation, secondaryAnimation) =>  MyDownload(platform: Theme.of(context).platform),
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
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1),
                        );
                      }
                      return const SizedBox(
                          height: 200,
                          child: Center(child: Text("No Episode Available")));
                    }),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<MoreLikeCubit, MoreLikeState>(
                  builder: (context, state) {
                if (state is LoadedState) {
                  return Column(
                    children: [
                      state.slider.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("More Like this"),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration:
                                                    const Duration(seconds: 1),
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const MoreLikeScreen(),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(0.0, 1.0);
                                                  const end = Offset.zero;
                                                  const curve = Curves.ease;
                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
                                                  return SlideTransition(
                                                    position:
                                                        animation.drive(tween),
                                                    child: child,
                                                  );
                                                },
                                              ));
                                        },
                                        icon: SvgPicture.asset(
                                            "asset/logo/rightarrow.svg",
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black))
                                  ]),
                            )
                          : Container(),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.slider.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreen(
                                                  id: state.slider[index]
                                                      .data[index].id,
                                                  url: state.slider[index]
                                                      .data[index].movieUrl,
                                                  title: state.slider[index]
                                                      .data[index].movieTitle,
                                                  description: state
                                                      .slider[index]
                                                      .data[index].movieDesc,
                                                  type: state.slider[index]
                                                      .data[index].movieType,
                                                  imgPath:
                                                  "$baseUrl/images/movies/${state
                                                      .slider[index].data[index]
                                                      .movieCover}",
                                                  seriesId: '',
                                                  mType: 'movie',
                                                )));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "$baseUrl/images/movies/${state.slider[index].data[index].movieCover}"),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                } else if (state is LoadingState) {
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFFF7F8F8),
                    highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("More Like this"),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const MoreLikeScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(0.0, 1.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ));
                                    },
                                    icon: SvgPicture.asset(
                                        "asset/logo/rightarrow.svg",
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black))
                              ]),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.props.length,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailsScreen(
                                                id: state.props[index]
                                                    .data[index].id,
                                                url: state.props[index]
                                                    .data[index].movieUrl,
                                                title: state.props[index]
                                                    .data[index].movieTitle,
                                                description: state.props[index]
                                                    .data[index].movieDesc,
                                                type: state.props[index]
                                                    .data[index].movieType,
                                                imgPath:
                                                    "$baseUrl/images/movies/${state.props[index].data[index].movieCover}",
                                                seriesId: '',
                                                mType: 'movie')));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "$baseUrl/images/movies/${state.props[index].data[index].movieCover}"),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
            )
          ],
        ),
      ),

      /*Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          */ /*JWVideoPlayer(
            controller: _controller,
            config: JWPlayerConfiguration(
                file:
                "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"),
          ),*/ /*
          langaugeSourceData.isNotEmpty?Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: langaugeSourceData.first.data.map((e){
              return InkWell(
                onTap: (){
                  print(e.languageName);
                  selectLanguageSource(e.languageName);
                  if(e.movieType=="youtube_url"){
                    podPlayerController.changeVideo(playVideoFrom: PlayVideoFrom.youtube(e.movieUrl));
                  }
                  else{
                    podPlayerController.changeVideo(playVideoFrom: PlayVideoFrom.vimeo(e.movieUrl));
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                  color: selectChip.contains(e.languageName)?Colors.deepPurple:Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Text(e.languageName),
                  ),
                ),
              );
            }).toList()),
          ):Container(),
          */ /*Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                shrinkWrap: true,

                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount:langaugeSourceData.length,itemBuilder:(context,index) =>
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InputChip(

                    selected:langaugeSourceData[index].data[index].selected, label:  Text(langaugeSourceData[index].data[index].languageName),
                    onSelected: (value){

                       setState(() {


                            langaugeSourceData[index].data[index].selected=value;

                       });

                         if(langaugeSourceData[index].data[index].movieType=="youtube_url"){
                           podPlayerController.changeVideo(playVideoFrom: PlayVideoFrom.youtube(langaugeSourceData[index].data[index].movieUrl));
                         }
                         else{
                           podPlayerController.changeVideo(playVideoFrom: PlayVideoFrom.vimeo(langaugeSourceData[index].data[index].movieUrl));
                         }


                    },
                    selectedColor: isSelected?Colors.deepPurple:Colors.black,
                  ),
                )),
            ),

          ),*/ /*
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex:2,
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.imgPath,
                          ),
                        )),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text(widget.title,
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(widget.language),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                              html.parse(widget.description).body!.text,textAlign: TextAlign.justify),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("${DateFormat("yyyy").format(widget.year)}",
                              style:
                              GoogleFonts.inter(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        elevation: MaterialStateProperty.all(10),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15)),
                        backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).brightness==Brightness.dark?Color(0xFF1B1F20):Colors.black),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Color(0xFF1B1F20)))),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("asset/logo/download.svg"),
                        SizedBox(width: 10),
                        Text("Download",style: GoogleFonts.inter(color: Colors.white)),
                      ],
                    )),
                OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      elevation: MaterialStateProperty.all(10),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15)),
                      backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).brightness==Brightness.dark?Color(0xFF1B1F20):Colors.black),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Color(0xFF1B1F20))),
                    ),
                    onPressed: () {
                      addtoWatchList("movie",widget.title);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text("Watchlist",
                            style: GoogleFonts.inter(color: Colors.white)),
                      ],
                    )),
                OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        elevation: MaterialStateProperty.all(10),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15)),
                        backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).brightness==Brightness.dark?Color(0xFF1B1F20):Colors.black),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Color(0xFF1B1F20)))),
                    onPressed: () {
                      shareDetails();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("asset/logo/share.svg",
                            width: 10, height: 10),
                        SizedBox(width: 10),
                        Text("Share",
                            style: GoogleFonts.inter(color: Colors.white)),
                      ],
                    ))
              ],
            ),
          ),
          */ /* Season Started */ /*
          flag==false?Container():BlocBuilder<SeriesCubit,SeriesState>(builder: (context,state){
            if(state is SeriesLoadedState){
              return DefaultTabController(
                length: length.value,
                child: SizedBox(
                    height: 40,
                    child: TabBar(
                      labelColor: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                      physics: const BouncingScrollPhysics(),
                      onTap: (int index){
                        print("Index $index");
                        debugPrint("Series Id ${state.slider[0].data[index].seriesId} and Season ID ${state.slider[0].data[index].id}");
                        BlocProvider.of<SeasonCubit>(context).fetchTVSeason(state.slider[0].data[index].seriesId,state.slider[0].data[index].id);
                      },
                        isScrollable: true,
                        indicatorColor: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,


                        tabs:state.slider[0].data.map((e){
                          return Text("${e.seasonName}");
                        }).toList(),
                        )
                ),
              );
            }
            return Container();
          }),

          flag==false?Container():BlocBuilder<SeasonCubit,SeasonState>(builder: (context,state){
            if(state is SeasonLoadedState){
              return SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.slider.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                          color: Theme.of(context).brightness==Brightness.dark?const Color(0xFF1B1F20):const Color(0xFF1B1F20),
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex:4,
                                child: Container(
                                 width:220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}"),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                     */ /* Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Text("35 min",
                                                style: GoogleFonts.inter(
                                                    color: Colors.white)),
                                          )),*/ /*
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,vertical: 10),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "asset/logo/play.svg",
                                                  width: 20,
                                                  height: 20),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Text(state.slider[index].data[index].episodeTitle,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: GoogleFonts
                                                          .inter(
                                                          color: Colors
                                                              .white)),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 220,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        state.slider[index].data[index].episodeTitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts
                                            .inter(
                                            color: Colors
                                                .white)),
                                  ),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          "asset/logo/download.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                                    ),
                                    Text("Download",style: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }),

              );
            }
            return const SizedBox(
                height: 200,
                child: Center(child: Text("No Record Found!!!")));
          }),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Like this"),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, secondaryAnimation) => const MoreLikeScreen(),
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
                      icon: SvgPicture.asset("asset/logo/rightarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black))
                ]),
          ),
          BlocBuilder<MoreLikeCubit,MoreLikeState>(builder: (context,state){
            if(state is LoadedState){
              return
                SizedBox(
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(id: state.slider[index].data[index].id, url: state.slider[index].data[index].movieUrl, title: state.slider[index].data[index].movieTitle, description: state.slider[index].data[index].movieDesc, year: state.slider[index].data[index].date, language: language, type: state.slider[index].data[index].movieType, imgPath: "$baseUrl/images/movies/${state.slider[index].data[index].movieCover}", seriesId: '')));
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
                    }),
              );
            }
            return
              Shimmer.fromColors(child: SizedBox(
              height: 250,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFF333945),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
            ), baseColor: const Color(0xFFF7F8F8),
              highlightColor: const Color(0xFFF7F8F8).withOpacity(.8),);
          }),
        ],
      ),*/
    );
  }
}
