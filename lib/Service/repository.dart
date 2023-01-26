import 'dart:math';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../const.dart';
/*To Call the Base Url With Dio */
class Repository{
  Dio dio=Dio();
  init(){
    dio.options.baseUrl=baseUrl;
    dio.interceptors.add(PrettyDioLogger());
    log(dio.options.hashCode);

  }
  Dio get sendRequest=>dio;
}