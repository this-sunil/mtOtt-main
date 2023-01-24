import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mtott/const.dart';
import 'package:mtott/pages/SearchScreen.dart';

import '../Service/cubit/LatestChannelCubit.dart';
import '../Service/state/LatestChannelState.dart';
import 'DetailsScreen.dart';
class ChannelScreen extends StatefulWidget {
  const ChannelScreen({Key? key}) : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  List<String> channel=[
    "asset/channel/HBO.png",
    "asset/channel/star utsav.png",
    "asset/channel/stargold.png",
    "asset/channel/star plus.png",
    "asset/channel/star world.png",
    "asset/channel/hotstar specials.png",
  ];
  @override
  void initState() {
    context.read<LatestChannelCubit>().fetchLatestChannel();
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
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black)),

        title: Text("Channels"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
        ],
      ),
      body:BlocBuilder<LatestChannelCubit,LatestChannelState>(builder:(context,state){
        if(state is LatestChannelLoadedState){
          return GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.slider.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 3/2),
              itemBuilder: (context,index){
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: (){
                    Navigator.push(context,PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) =>  DetailsScreen(id: state.slider[index].data[index].id,url:state.slider[index].data[index].channelUrl, title: state.slider[index].data[index].channelTitle, description: state.slider[index].data[index].channelDesc,  type: state.slider[index].data[index].channelType, imgPath: "$baseUrl/images/${state.slider[index].data[index].channelThumbnail}", seriesId: '', mType: '',),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("$baseUrl/images/${state.slider[index].data[index].channelThumbnail}")),
                      ),
                    ),
                  ),
                );
              });
        }
        else if(state is LatestChannelErrorState){
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        return const Center(child: CircularProgressIndicator(color:Colors.white));
      }),

    );
  }
}
