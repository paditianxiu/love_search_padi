// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:love_search_padi/pages/home/classification_page.dart';
import 'package:love_search_padi/pages/home/home_page.dart';
import 'package:love_search_padi/pages/home/mine_page.dart';
import 'package:love_search_padi/pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true),
        debugShowCheckedModeBanner: false,
        title: "爱搜片",
        home: const MainPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/mine': (context) => const MinePage(),
          '/classiFication': (context) => const ClassificationPage(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
        ]);
  }
}
