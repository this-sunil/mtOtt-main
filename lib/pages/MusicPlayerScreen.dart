import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lottie/lottie.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/DashBoardScreen.dart';
import 'package:mtott/utility/theme/Database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Service/cubit/MusicCategoryTypeCubit.dart';
import '../Service/model/CommentModel.dart';
import '../Service/state/MusicCategoryTypeState.dart';
import '../main.dart';
import 'SearchScreen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final int index;
  final String title;
  final String url;
  final String imgPath;
  final String subtitle;
  const MusicPlayerScreen(
      {Key? key,
      required this.index,
      required this.title,
      required this.url,
      required this.subtitle, required this.imgPath})
      : super(key: key);
  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with WidgetsBindingObserver,TickerProviderStateMixin{
  late final AnimationController _controller;
  final String url =
      "https://ghantalele.com/uploads/files/data-24/11566/Dosti_192(Ghantalele.com).mp3";
  GlobalKey<FormState> formKey =
      GlobalKey();
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  TextEditingController commentController = TextEditingController();
  Future download(String id, String url, String title, String imgPath,
      String musicType) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
              url: url,
              savedDir: baseStorage!.path,
              openFileFromNotification: true,
              allowCellular: true,
              saveInPublicStorage: false,
              fileName: title,
              showNotification: true)
          .then((value) {
        helper.addDownload(id, title, url, "", "", imgPath, "", musicType);
        final banner = AwesomeSnackbarContent(
            title: 'Success',
            message: "Download Successfully",
            contentType: ContentType.success,
            inMaterialBanner: true);
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(
              SnackBar(content: banner, backgroundColor: Colors.transparent));

        //helper.addDownload(widget.id, widget.title,widget.url,widget.description,"${widget.seasonId}", widget.imgPath,widget.type,widget.seriesId);
      });
    }
  }

  multipleFav(String title, String id, String url, String image,
      String subtitle) async {
    if (selectFav.contains(title)) {
      selectFav.remove(title);
      helper.removeFav(title);
    } else {
      selectFav.add(title);
      helper.addFav(currentIndex.toString(), title, image, url, subtitle);
    }
    setState(() {});
  }

  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  playMusic() async {
    await player.setAudioSource(
      AudioSource.uri(
        Uri.parse(
           widget.url),
        tag: MediaItem(
          id:"${widget.index}",
          album: widget.subtitle,
          title: widget.title,
          artUri: Uri.parse(widget.imgPath),
        ),
      ),
        preload: false,
      );

      player.play();
      player.positionStream.listen((event) {
        //print("Position at init " +position.toString());
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$duration")));
        if (mounted) {
          setState(() {
            position = event;
          });
        }
      });
      player.durationStream.listen((newDuration) {
        if (newDuration != null) {
          duration = newDuration;
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$duration")));
        }
      });





    }





  String imageUrl = "";
  late PageController pageController;
  DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);


    FlutterDownloader.registerCallback(downloadCallback);
    playMusic();
    debugPrint("${widget.url} And Index ${widget.title} ${widget.index}");
    helper.init();
    pageController = PageController(initialPage: widget.index);


    /* FacebookAuth.instance.getUserData().then((value){
      imageUrl=value["picture"]["data"]["url"];
    });*/

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {

      player.stop();
    } else {
       player.play();
    }
  }


  int currentIndex = 0;

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<CommentModel> comment = [];
  showComment(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString("uid").toString();
    final resp = await post(Uri.parse(showComments), body: {
      "post_id": id,
      "user_id": uid,
    });
    final result = commentModelFromJson(resp.body);
    if (resp.statusCode == 200) {
      if (result.status) {
        comment.clear();
        for (int i = 0; i < result.data.length; i++) {
          comment.add(CommentModel(
              status: result.status,
              message: result.message,
              data: result.data));
        }
      }
    } else {
      debugPrint("Error in Api ${resp.request!.url}");
    }
    setState(() {});
  }

  comments(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString("uid").toString();
    final resp = await post(Uri.parse(commentApi), body: {
      "comment_text": commentController.text,
      "post_id": id,
      "user_id": uid,
    });
    debugPrint(resp.body);
    final result = jsonDecode(resp.body);

    if (resp.statusCode == 200) {
      if (result["status"]) {
        comment.clear();
        showComment(id);
        final banner = AwesomeSnackbarContent(
            title: 'Success',
            message: result["message"],
            contentType: ContentType.success,
            inMaterialBanner: true);
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(
              SnackBar(content: banner, backgroundColor: Colors.transparent));
        commentController.clear();
      } else {
        final banner = AwesomeSnackbarContent(
            title: 'Failed',
            message: result["message"],
            contentType: ContentType.success,
            inMaterialBanner: true);
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(
              SnackBar(content: banner, backgroundColor: Colors.transparent));
        commentController.clear();
      }
    } else {
      debugPrint("Error in Api ${resp.request!.url}");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("asset/logo/leftarrow.svg",
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)),
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SearchScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
              },
              icon: SvgPicture.asset("asset/logo/search.svg",
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black))
        ],
      ),
      body: BlocBuilder<MusicCategoryTypeCubit, MusicCategoryTypeState>(
        builder: (context, state) {
          if (state is MusicCategoryTypeLoadingState) {
            return Center(child:CircularProgressIndicator());
          }
          else if (state is MusicCategoryTypeLoadedState) {
            return PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: state.slider.length,
                onPageChanged: (value) {
                  debugPrint("Current Value $value");
                  setState(() {

                    player.stop();

                    player.setAudioSource(
                      preload: false,
                        AudioSource.uri(Uri.parse("$baseUrl/${state.slider[value].data[value].music}"),tag: MediaItem(id: state.slider[value].data[value].id, title: state.slider[value].data[value].title,album: state.slider[value].data[value].singer,artUri: Uri.parse("$baseUrl/${state.slider[value].data[value].musicCover}"))),
                    );
                    player.play();
                  });
                },
                itemBuilder: (context, index) {
                  currentIndex = index;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "$baseUrl/${state.slider[index].data[index].musicCover}"),
                        colorFilter: const ColorFilter.mode(
                            Colors.black54, BlendMode.saturation),
                      ),
                    ),
                    child: Container(
                      height: 300,
                      color: Colors.black54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              state.slider[index].data[index]
                                                  .musicType,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w500)))),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.slider[index].data[index].title,
                                    style: GoogleFonts.inter(
                                        color: Colors.white, fontSize: 16)),
                               player.playing?Lottie.asset("asset/logo/wave.json",animate: true,width: 50,height: 50,onLoaded: (composition) {
                                 // Configure the AnimationController with the duration of the
                                 // Lottie file and start the animation.
                                 _controller
                                   ..duration = composition.duration
                                   ..forward();
                               },):Container(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20),
                            child: Row(
                              children: [
                                Text(state.slider[index].data[index].singer,
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFFACA9A9),
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 20),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      multipleFav(
                                          state.slider[index].data[index]
                                              .title,
                                          state.slider[index].data[index].id,
                                          state.slider[index].data[index]
                                              .music,
                                          state.slider[index].data[index]
                                              .musicCover,
                                          state.slider[index].data[index]
                                              .musicType);
                                    },
                                    icon: selectFav.contains(state
                                            .slider[index].data[index].title)
                                        ? SvgPicture.asset(
                                            "asset/logo/like.svg",
                                            width: 20,
                                            height: 20)
                                        : SvgPicture.asset(
                                            "asset/logo/unlike.svg",
                                            width: 20,
                                            height: 20,
                                          )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showComment(state
                                            .slider[index].data[index].id);
                                      });
                                      showBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(0))),
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return SizedBox(
                                                height: 400,
                                                child: Card(
                                                    margin: EdgeInsets.zero,
                                                    clipBehavior:
                                                        Clip.hardEdge,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius
                                                                    .circular(
                                                                        0),
                                                            bottomLeft: Radius
                                                                .circular(
                                                                    0))),
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: [
                                                        comment.isNotEmpty
                                                            ? ListView
                                                                .builder(
                                                                    itemCount:
                                                                        comment
                                                                            .length,
                                                                    physics: const BouncingScrollPhysics(
                                                                        parent:
                                                                            AlwaysScrollableScrollPhysics()),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        title: Text(
                                                                            comment[index].data[index].commentText,
                                                                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                                                                      );
                                                                    })
                                                            : const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Center(
                                                              child:
                                                                  TextFormField(
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                controller:
                                                                    commentController,
                                                                cursorColor:
                                                                    Colors
                                                                        .black54,
                                                                autofocus:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Type here...",
                                                                  hintStyle: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  prefixIcon:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: imageUrl
                                                                            .isNotEmpty
                                                                        ? CircleAvatar(
                                                                            backgroundImage: NetworkImage(imageUrl))
                                                                        : Icon(Icons.account_circle_sharp),
                                                                  ),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              comments(state.slider[index].data[index].id);
                                                                            });
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.send)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    /*CommentBox(


                                              userImage: CommentBox.commentImageParser(
                                                  imageURLorPath: imageUrl),
                                              child: commentChild(filedata),
                                              labelText: 'Write a comment...',
                                              errorText: 'Comment cannot be blank',
                                              withBorder: true,
                                              sendButtonMethod: () {
                                                if (formKey.currentState!.validate()) {
                                                  print(commentController.text);
                                                  setState(() {
                                                    FacebookAuth.instance.getUserData().then((value){
                                                      debugPrint(value.toString());
                                                      var values = {
                                                        'name': value["name"],
                                                        'pic': value["picture"]["data"]["url"]??"",
                                                        'message': commentController.text,
                                                        'date': '${DateTime.now()}'
                                                      };
                                                      filedata.insert(0, values);
                                                      debugPrint(filedata.toString());
                                                    });
                                                  });

                                                  FocusScope.of(context).unfocus();
                                                } else {
                                                  print("Not validated");
                                                }
                                              },
                                              formKey: formKey,
                                              commentController: commentController,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              sendWidget: const Icon(Icons.send_sharp, size: 30, color: Colors.white),
                                            ),*/
                                                    ),
                                              );
                                            });
                                          });
                                    },
                                    icon: SvgPicture.asset(
                                        "asset/logo/comment.svg")),
                                IconButton(
                                    onPressed: () async {
                                      await FlutterShare.share(
                                          title: state.slider[index]
                                              .data[index].singer,
                                          text:state.slider[index]
                                              .data[index].title,
                                          linkUrl: "$baseUrl/${state.slider[index]
                                              .data[index].musicCover}");
                                    },
                                    icon: SvgPicture.asset(
                                        "asset/logo/share.svg",
                                        width: 20,
                                        height: 20)),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          var tempDir =
                                              await getTemporaryDirectory();
                                          String fullPath =
                                              "${tempDir.path}/music.mp3";
                                          print('full path $fullPath');
                                          download(
                                              state.slider[index].data[index]
                                                  .id,
                                              "$baseUrl/${state.slider[index].data[index].music}",
                                              state.slider[index].data[index]
                                                  .title,
                                              "$baseUrl/${state.slider[index].data[index].musicCover}",
                                              state.slider[index].data[index]
                                                  .musicType);
                                          //download(state.slider[index].data[index].id,"$baseUrl/${state.slider[index].data[index].music}",state.slider[index].data[index].title,"$baseUrl/${state.slider[index].data[index].musicCover}",state.slider[index].data[index].musicType);
                                          /* await Dio().download("$baseUrl/${state.slider[index].data[index].music}", fullPath, onReceiveProgress: (rec, total) {
                                     print("Rec: $rec , Total: $total");

                                     setState(() {
                                       */ /*downloading = true;
                                progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";*/ /*
                                     });
                                   }).then((value) {
                                      helper.addDownload(state.slider[index].data[index].id,state.slider[index].data[index].title,state.slider[index].data[index].music,"","", "$baseUrl/${state.slider[index].data[index].musicCover}","",state.slider[index].data[index].musicType);
                                      QuickAlert.show(context: context, type: QuickAlertType.success,title: "Music Download Successfully",animType: QuickAlertAnimType.slideInLeft,confirmBtnColor: Colors.green,borderRadius: 5);
                                   });*/
                                        },
                                        icon: SvgPicture.asset(
                                            "asset/logo/downloads.svg",
                                            width: 20,
                                            height: 20)),
                                  ],
                                ),
                              ],
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 4),
                            child: Slider(
                                max: duration.inSeconds.toDouble(),
                                min: 0.0,
                                inactiveColor: Colors.grey,
                                activeColor: Colors.white,
                                value: position.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  position = Duration(seconds: value.toInt());
                                  setState(() {
                                    player.seek(position);

                                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Position in Player ${position.toString()}")));
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
