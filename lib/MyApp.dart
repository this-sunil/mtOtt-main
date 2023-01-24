import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/cubit/RunningHomeSliderCubit.dart';
import 'package:mtott/utility/theme/ThemeCubit.dart';

import 'MainScreen.dart';
import 'Service/cubit/GenresCategoryCubit.dart';
import 'Service/cubit/GenresCubit.dart';
import 'Service/cubit/InternetCubit.dart';
import 'Service/cubit/LatestChannelCubit.dart';
import 'Service/cubit/LatestMovieCubit.dart';
import 'Service/cubit/MoreLikeCubit.dart';
import 'Service/cubit/MusicCategoryCubit.dart';
import 'Service/cubit/MusicCategoryTypeCubit.dart';
import 'Service/cubit/PopularCubit.dart';
import 'Service/cubit/RuningSongCubit.dart';
import 'Service/cubit/RuningWebSeriesCubit.dart';
import 'Service/cubit/RunningMovieCubit.dart';
import 'Service/cubit/SearchCubit.dart';
import 'Service/cubit/SeasonCubit.dart';
import 'Service/cubit/SeriesCubit.dart';
import 'Service/cubit/ShowsCubit.dart';
import 'Service/cubit/TopPicksCubit.dart';
import 'Service/cubit/UpComingHomeSliderCubit.dart';
import 'Service/cubit/UpComingMovieSliderCubit.dart';
import 'Service/cubit/UpComingSeriesCubit.dart';
import 'Service/cubit/UpComingSongCubit.dart';
import 'Service/cubit/WatchListCubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider<ThemeCubit>(create: (context)=>ThemeCubit()),
          BlocProvider(create: (context)=>InternetCubit()),
          BlocProvider(create: (context)=>UpComingHomeSliderCubit()),
          BlocProvider(create: (context)=>RunningHomeSliderCubit()),
          BlocProvider(create: (context)=>UpComingMovieSliderCubit()),
          BlocProvider(create: (context)=>RuningMovieSliderCubit()),
          BlocProvider(create: (context)=>UpComingSeriesSliderCubit()),
          BlocProvider(create: (context)=>RunningWebSeriesCubit()),
          BlocProvider(create: (context)=>UpComingSongsCubit()),
          BlocProvider(create: (context)=>RuningSongCubit()),
          BlocProvider(create: (context)=>LatestMovieCubit()),
          BlocProvider(create: (context)=>ShowsCubit()),
          BlocProvider(create: (context)=>LatestChannelCubit()),
          BlocProvider(create: (context)=>GenresCubit()),
          BlocProvider(create: (context)=>PopularCubit()),
          BlocProvider(create: (context)=>SeriesCubit()),
          BlocProvider(create: (context)=>SeasonCubit()),
          BlocProvider(create: (context)=>SearchCubit()),
          BlocProvider(create: (context)=>TopPicksCubit()),
          BlocProvider(create: (context)=>MusicCategoryCubit()),
          BlocProvider(create: (context)=>GenresCategoryCubit()),
          BlocProvider(create: (context)=>MusicCategoryTypeCubit()),
          BlocProvider(create: (context)=>WatchListCubit()),
          BlocProvider(create: (context)=>MoreLikeCubit()),
        ],
        child: const MainScreen());
  }
}