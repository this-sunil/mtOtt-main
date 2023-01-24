import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:mtott/pages/DetailsScreen.dart';
import 'package:mtott/utility/theme/Database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Service/cubit/SeasonCubit.dart';
import '../Service/cubit/SeriesCubit.dart';
import '../Service/state/SeasonState.dart';
import '../Service/state/SeriesState.dart';
import '../const.dart';
import 'SearchScreen.dart';

class TvSeriesScreen extends StatefulWidget {
  final String title;
  final String imgPath;
  final String id;
  final String seasonId;
  final String description;
  const TvSeriesScreen(
      {Key? key,
      required,
      required this.title,
      required this.imgPath,
      required this.id,
      required this.description,
      required this.seasonId})
      : super(key: key);

  @override
  State<TvSeriesScreen> createState() => _TvSeriesScreenState();
}

class _TvSeriesScreenState extends State<TvSeriesScreen>
    with SingleTickerProviderStateMixin {
  DatabaseHelper helper = DatabaseHelper();
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
  @override
  void initState() {
    FlutterDownloader.registerCallback(downloadCallback);
    helper.init();
    context.read<SeriesCubit>().fetchTVSeries(widget.id);
    context.read<SeasonCubit>().fetchTVSeason(widget.id, widget.seasonId);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<SeriesCubit>().fetchTVSeries(widget.id);
    context.read<SeasonCubit>().fetchTVSeason(widget.id, widget.seasonId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, scroll) {
        return [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : const Color(0xFF333945),
            forceElevated: scroll,
            expandedHeight: 300,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                      color: scroll == true ? Colors.grey : Colors.white)),
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset("asset/logo/leftarrow.svg",
                    color: scroll == true ? Colors.grey : Colors.white)),
            title: Text(widget.title,
                style: TextStyle(
                    color: scroll == true ? Colors.grey : Colors.white)),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.id,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.imgPath),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(parse(widget.description).body!.text,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(0xFF333945)),
                    textAlign: TextAlign.justify)),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SeriesCubit, SeriesState>(
                builder: (context, state) {
              if (state is SeriesLoadedState) {
                return DefaultTabController(
                  length: state.slider.length,
                  child: SizedBox(
                      height: 40,
                      child: TabBar(
                        labelPadding: EdgeInsets.all(8),
                        labelColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        physics: const BouncingScrollPhysics(),
                        onTap: (int index) {
                          print("Index $index");
                          debugPrint(
                              "Series Id ${state.slider[0].data[index].seriesId} and Season ID ${state.slider[0].data[index].id}");
                          BlocProvider.of<SeasonCubit>(context).fetchTVSeason(
                              state.slider[0].data[index].seriesId,
                              state.slider[0].data[index].id);
                        },
                        isScrollable: true,
                        indicatorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        tabs: state.slider[0].data.map((e) {
                          return Text(e.seasonName);
                        }).toList(),
                      )),
                );
              }
              return Container();
            }),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SeasonCubit, SeasonState>(
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
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  DetailsScreen(
                                      id: state.slider[index].data[index].id,
                                      url: state
                                          .slider[index].data[index].episodeUrl,
                                      title: state.slider[index].data[index]
                                          .episodeTitle,
                                      description: state
                                          .slider[index].data[index].subtitle,
                                      type: state.slider[index].data[index]
                                          .episodeType,
                                      imgPath:
                                          '$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}',
                                      seriesId: state
                                          .slider[index].data[index].seriesId,
                                      seasonId: state
                                          .slider[index].data[index].seasonId,
                                      mType: 'series'),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                      child: Hero(
                        tag: state.slider[index].data[index].id,
                        child: Card(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF333945)
                                    : Colors.white60,
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    width: 220,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}"),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 10),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "asset/logo/play.svg",
                                                    width: 20,
                                                    height: 20),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                        state
                                                            .slider[index]
                                                            .data[index]
                                                            .episodeTitle,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.inter(
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
                                          padding: const EdgeInsets.all(8.0),
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
                                      var status =
                                          await Permission.storage.request();
                                      if (status.isGranted) {
                                        final baseStorage =
                                            await getExternalStorageDirectory();

                                        await FlutterDownloader.enqueue(
                                                url: state.slider[index]
                                                    .data[index].episodeUrl,
                                                savedDir: baseStorage!.path,
                                                openFileFromNotification: true,
                                                allowCellular: true,
                                                saveInPublicStorage: true,
                                                fileName: state.slider[index]
                                                    .data[index].episodeTitle,
                                                showNotification: true)
                                            .then((value) {
                                          helper.addDownload(
                                              state
                                                  .slider[index].data[index].id,
                                              state.slider[index].data[index]
                                                  .episodeTitle,
                                              state.slider[index].data[index]
                                                  .episodeUrl,
                                              '',
                                              state.slider[index].data[index]
                                                  .seasonId,
                                              "$baseUrl/images/episodes/${state.slider[index].data[index].episodePoster}",
                                              state.slider[index].data[index]
                                                  .seriesId,
                                              state.slider[index].data[index]
                                                  .episodeType);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
                );
              }
              return const SizedBox(
                  height: 200,
                  child: Center(child: Text("No Episode Available")));
            }),
          ),
        ],
      ),
    ));
  }
}
