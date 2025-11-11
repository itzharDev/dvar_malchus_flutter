import 'package:dvarmalchus_flutter/core/cubit/analytics_cubit.dart';
import 'package:dvarmalchus_flutter/core/dm_pdf_viewer/pdfviewer_cubit.dart';
import 'package:dvarmalchus_flutter/core/rest_client.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/cubit/dvarmalchus_cubit.dart';
import 'package:dvarmalchus_flutter/settings/cubit/settings_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // var hiveManager = HiveManager();
  // await hiveManager.init();

  final dio = Dio();

  // locator.registerSingleton<AnalyticsCubit>(AnalyticsCubit());

  locator.registerSingleton<Dio>(dio);
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerSingleton<RestClient>(RestClient(dio));
  locator.registerSingleton<DvarmalchusCubit>(DvarmalchusCubit(locator.get()));
  locator.registerSingleton<DMPdfViewerCubit>(DMPdfViewerCubit());
  locator.registerSingleton<AnalyticsCubit>(AnalyticsCubit());
  locator.registerSingleton<SettingsCubit>(SettingsCubit());
}
