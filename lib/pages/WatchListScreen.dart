import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/cubit/WatchListCubit.dart';
import 'package:mtott/Service/state/WatchListState.dart';
import 'package:mtott/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SearchScreen.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({Key? key}) : super(key: key);

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {

  HashSet selectItem=HashSet();
  multipleSelection(String id){
    if(selectItem.contains(id)){
      selectItem.remove(id);
    }
    else{
      selectItem.add(id);
    }
    setState(() {});
  }
  removeWatchlist(String watchId) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    userId=pref.get("uid").toString();
    final resp=await post(Uri.parse(removeWatchList),body: {
      "userid":userId,
      "watch":watchId,
    });
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      context.read<WatchListCubit>().fetchWatchList(userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
    }
    else{
      debugPrint("ERROR ${resp.statusCode} ${resp.request!.url}");
    }
  }
  String userId="";
  fetchWatchList() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    userId=pref.get("uid").toString();
    debugPrint("UserID $userId");
    context.read<WatchListCubit>().fetchWatchList(userId);
    setState(() {});
  }
  @override
  void initState() {
    fetchWatchList();

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
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),
        title: const Text("Watch List"),
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
          }, icon: SvgPicture.asset("asset/logo/search.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black))
        ],
      ),
      body:RefreshIndicator(
        onRefresh: () async{
          context.read<WatchListCubit>().fetchWatchList(userId);
        },
        child: BlocBuilder<WatchListCubit,WatchListState>(

          builder: (context,state){
            if(state is LoadedState){
              return ListView.builder(
                  itemCount:state.slider.length,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context,index){
                    return Card(
                     
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      child: ListTile(
                       contentPadding: const EdgeInsets.symmetric(vertical: 5),

                      leading: CircleAvatar(
                          maxRadius: 35,
                          backgroundImage: NetworkImage(state.slider[index].data[index].movieCover.isEmpty?"$baseUrl/images/series/${state.slider[index].data[index].seriesCover}":"$baseUrl/images/movies/${state.slider[index].data[index].movieCover}")),
                      title: Text(state.slider[index].data[index].movieTitle.isEmpty?state.slider[index].data[index].seriesName:state.slider[index].data[index].movieTitle),

                      onLongPress: (){
                        multipleSelection(state.slider[index].data[index].id);
                      },
                     trailing: selectItem.contains(state.slider[index].data[index].id)?IconButton(onPressed: (){
                       removeWatchlist(state.slider[index].data[index].id);
                       selectItem.remove(state.slider[index].data[index].id);

                     },icon: const Icon(Icons.delete,color: Colors.white)):null,
                    ),
                  );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },

        ),
      ),
    );
  }
}
