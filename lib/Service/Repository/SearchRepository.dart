import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/model/LatestMoviesModel.dart';
import 'package:mtott/Service/model/SearchModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import 'package:dio/dio.dart';
/*To Call The Api*/
class SearchRepository{
  Repository repository=Repository();
  List<SearchModel> model=[];
  List<Movie> movies=[];
  List<Series> series=[];
  List<Song> songs=[];
  List<Channel> channels=[];
  /*Start Search Screen Api With Bloc State Management*/
  Future<List<SearchModel>> searchMovie(String title) async{
    repository.init();
    final res=await post(Uri.parse(searchApi),body: {"search":title});
    repository.sendRequest.interceptors.add(PrettyDioLogger());

    final  data=searchModelFromJson(res.body);
    debugPrint("Response ${data.searchResponse.series.length}");
    if(res.statusCode==200){
      model.clear();
      movies.clear();
      songs.clear();
      series.clear();
      channels.clear();
      debugPrint("Search Response ${data}");

      data.searchResponse.movies.map((e) => movies.add(Movie(id: e.id, languageId: e.languageId, genreId: e.genreId, movieType: e.movieType, movieTitle: e.movieTitle, movieCover: e.movieCover, moviePoster: e.moviePoster, movieUrl: e.movieUrl, videoId: e.videoId, movieDesc: e.movieDesc, totalViews: e.totalViews, totalRate: e.totalRate, rateAvg: e.rateAvg, isFeatured: e.isFeatured, isSlider: e.isSlider, subtitle: e.subtitle, isQuality: e.isQuality, status: e.status, director: e.director, price: e.price, date: e.date, isTopPick: e.isTopPick))).toList();
      data.searchResponse.series.map((e) => series.add(Series(id: e.id, seriesName: e.seriesName, seriesDesc: e.seriesDesc, seriesPoster: e.seriesPoster, seriesCover: e.seriesCover, totalViews: e.totalViews, totalRate: e.totalRate, rateAvg: e.rateAvg, isFeatured: e.isFeatured, isSlider: e.isSlider, status: e.status, totalSeason: e.totalSeason, seasonData: e.seasonData))).toList();
      data.searchResponse.songs.map((e) => songs.add(Song(id: e.id, musicType: e.musicType, title: e.title, singer: e.singer, musicCover: e.musicCover, music: e.music, totalViews: e.totalViews, status: e.status, deleted: e.deleted))).toList();
      data.searchResponse.channels.map((e) => channels.add(Channel(id: e.id, catId: e.catId, channelType: e.channelType, channelTitle: e.channelTitle, channelUrl: e.channelUrl, channelTypeIos: e.channelTypeIos, channelUrlIos: e.channelUrlIos, channelPoster: e.channelPoster, channelThumbnail: e.channelThumbnail, channelDesc: e.channelDesc, featuredChannel: e.featuredChannel, sliderChannel: e.sliderChannel, totalViews: e.totalViews, totalRate: e.totalRate, rateAvg: e.rateAvg, status: e.status, userAgent: e.userAgent, userAgentType: e.userAgentType, userAgentName: e.userAgentName))).toList();
      for(int i=0;i<1;i++){
        model.add(SearchModel(status: data.status, searchResponse: SearchResponse(movies: movies,channels: channels,series: series,songs: songs)));
      }
      debugPrint("Model $model");
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;

  }
/*End Search Screen Api With Bloc State Management!!!*/


}