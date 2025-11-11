import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  HiveManager();
  Future<void> init() async {
    await Hive.initFlutter();
  }
}
