import 'dart:convert';

import 'package:dvarmalchus_flutter/core/network/response/config.dart';
import 'package:dvarmalchus_flutter/core/network/response/dvarmalchus.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

//flutter pub run build_runner build --delete-conflicting-outputs
@RestApi(baseUrl: "https://dvarmalchus.co.il/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/getConfigurations")
  Future<DvarMalchusConfig> getConfig();

  @POST("/getDvarMalchusILMembers")
  Future<Dvarmalchus> getDvarMalchus(@Body() Map<String, dynamic> map);
}
