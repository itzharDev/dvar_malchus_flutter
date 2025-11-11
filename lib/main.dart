import 'package:dvarmalchus_flutter/core/constants/constants.dart';
import 'package:dvarmalchus_flutter/core/ioc.dart';
import 'package:dvarmalchus_flutter/firebase_options.dart';
import 'package:dvarmalchus_flutter/home_page/presentation/pages/home_page.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var tree = DebugTree();
  tree.colorizeMap["D"] = ColorizeStyle(
      [AnsiStyle(AnsiSelection.foreground, color: AnsiColor.cyan)]);
  tree.colorizeMap["E"] = ColorizeStyle(
      [AnsiStyle(AnsiSelection.foreground, color: AnsiColor.red)]);
  tree.colorizeMap["I"] = ColorizeStyle(
      [AnsiStyle(AnsiSelection.foreground, color: AnsiColor.blue)]);
  tree.colorizeMap["W"] = ColorizeStyle(
      [AnsiStyle(AnsiSelection.foreground, color: AnsiColor.green)]);
  Fimber.plantTree(tree);

  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: DMColors.primaryColor, fontFamily: 'Orion'),
      home: const HomePageWidget(),
    );
  }
}
