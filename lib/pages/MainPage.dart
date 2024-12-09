// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:love_search_padi/pages/home/MinePage.dart';
import 'package:love_search_padi/pages/home/HomePage.dart';
import 'package:love_search_padi/pages/home/ClassificationPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  var widgets = <Widget>[
    const HomePage(),
    const ClassificationPage(),
    const MinePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: '主页',
            ),
            NavigationDestination(
              icon: Icon(Icons.loyalty_outlined),
              selectedIcon: Icon(Icons.loyalty),
              label: '分类',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: '我的',
            ),
          ],
        ),
        body: IndexedStack(index: currentPageIndex, children: widgets));
  }
}
