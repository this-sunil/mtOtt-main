import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:mtott/utility/theme/Database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/model/CommentModel.dart';
import '../main.dart';
import 'DownloadTask.dart';
import 'SearchScreen.dart';

class SearchMusicScreen extends StatefulWidget {
  final String id;
  final String title;
  final String url;
  final String imgPath;
  final String singer;
  final String type;
  const SearchMusicScreen(
      {Key? key,
        required this.id,
        required this.title,
        required this.url,
        required this.type, required this.imgPath, required this.singer})
      : super(key: key);
  @override
  State<SearchMusicScreen> createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen>
    with WidgetsBindingObserver,TickerProviderStateMixin{
  late final AnimationController _controller;
  final String url =
      "https://ghantalele.com/uploads/files/data-24/11566/Dosti_192(Ghantalele.com).mp3";
  GlobalKey<FormState> formKey =
  GlobalKey();
  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  TextEditingController commentController = TextEditingController();
  Future download(String id, String url, String title, String imgPath,
      String musicType) async {


        helper.addDownload(id, title, url, "", "", imgPath, "", musicType);
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
  String username="";
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  playMusic() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    username=pref.getString("fullName").toString();
    await player.setAudioSource(
      AudioSource.uri(
        Uri.parse(
            widget.url),
        tag: MediaItem(
          id:"${widget.id}",
          album: widget.singer,
          title: widget.title,
          artUri: Uri.parse("$baseUrl/${widget.imgPath}"),

        ),
      ),
      preload: false,
    );


    player.play();
    player.positionStream.listen((event) {
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
    player.playerStateStream.listen((event) {
      if(event.processingState==ProcessingState.completed){
        setState(() {
          duration=Duration.zero;
          position=Duration.zero;
          player.stop();
        });
        player.setShuffleModeEnabled(true);
        pageController.nextPage(duration: const Duration(seconds: 1), curve:Curves.easeOutExpo);
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
    debugPrint("${widget.url} And Index ${widget.title} ${widget.id}");
    helper.init();
    pageController = PageController(initialPage: 0);


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
      body:PageView.builder(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 1,
          onPageChanged: (value) {


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
                      widget.imgPath),
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
                                      widget.type,
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
                          Text(widget.title,
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 16)),
                          player.position!=player.duration?Lottie.asset("asset/logo/wave.json",animate: true,width: 50,height: 50,onLoaded: (composition) {

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
                          Text(widget.singer,
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
                                    widget
                                        .title,
                                   widget.id,
                                    widget.url,
                                    widget.imgPath,
                                    widget.type);
                              },
                              icon: selectFav.contains(widget.title)
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
                                  showComment(widget.id);
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
                                    builder: (context) => SizedBox(
                                      height: 500,
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
                                                    leading: CircleAvatar(child: FirebaseAuth.instance.currentUser==null?SvgPicture.asset("asset/logo/user.svg"):CircleAvatar(backgroundImage: NetworkImage("${FirebaseAuth.instance.currentUser!.photoURL}"))),
                                                    title: Text(username),
                                                    subtitle: Text(
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
                                                              comments(widget.id);
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
                                        ),
                                      ),
                                    ));
                              },
                              icon: SvgPicture.asset(
                                  "asset/logo/comment.svg")),
                          IconButton(
                              onPressed: () async {
                                await FlutterShare.share(
                                    title: widget.singer,
                                    text:widget.title,
                                    linkUrl: widget.imgPath);
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
                                        widget.id,
                                        widget.url,
                                        widget
                                            .title,
                                        widget.imgPath,
                                        widget.type);

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
                            position = Duration(seconds: value.toDouble().toInt());
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
          })
    );
  }
}
