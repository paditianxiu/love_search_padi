// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../widgets/app_layout.dart';
import 'home/classification_page.dart';
import 'home/home_page.dart';
import 'home/mine_page.dart';
class MainPage extends StatefulWidget {
  final List<Widget>? pages;

  const MainPage({super.key, this.pages});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  late final _pages =
      widget.pages ?? [const HomePage(), const ClassificationPage(), const MinePage()];

  @override
  void initState() {
    super.initState();
    assert(widget.pages == null || widget.pages!.length == 3);
  }

  void _selectPage(int index) => setState(() => currentPageIndex = index);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final desktop =
              constraints.maxWidth >= AppLayout.navigationBreakpoint;
          final extended =
              constraints.maxWidth >= AppLayout.expandedNavigationBreakpoint;
          return Scaffold(
            bottomNavigationBar: desktop
                ? null
                : NavigationBar(
                    onDestinationSelected: _selectPage,
                    selectedIndex: currentPageIndex,
                    destinations: const [
                      NavigationDestination(
                        selectedIcon: Icon(Icons.home),
                        icon: Icon(Icons.home_outlined),
                        label: '主页',
                      ),
                      NavigationDestination(
                        selectedIcon: Icon(Icons.loyalty),
                        icon: Icon(Icons.loyalty_outlined),
                        label: '分类',
                      ),
                      NavigationDestination(
                        selectedIcon: Icon(Icons.people),
                        icon: Icon(Icons.people_outline),
                        label: '我的',
                      ),
                    ],
                  ),
            body: Row(
              children: [
                if (desktop) ...[
                  SafeArea(
                    child: NavigationRail(
                      extended: extended,
                      minExtendedWidth: 200,
                      selectedIndex: currentPageIndex,
                      onDestinationSelected: _selectPage,
                      labelType: extended
                          ? NavigationRailLabelType.none
                          : NavigationRailLabelType.all,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.movie_filter_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                            if (extended) ...[
                              const SizedBox(width: 12),
                              Text(
                                '爱搜片',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ],
                        ),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          selectedIcon: Icon(Icons.home),
                          icon: Icon(Icons.home_outlined),
                          label: Text('主页'),
                        ),
                        NavigationRailDestination(
                          selectedIcon: Icon(Icons.loyalty),
                          icon: Icon(Icons.loyalty_outlined),
                          label: Text('分类'),
                        ),
                        NavigationRailDestination(
                          selectedIcon: Icon(Icons.people),
                          icon: Icon(Icons.people_outline),
                          label: Text('我的'),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                ],
                Expanded(
                  key: const ValueKey('main-content'),
                  child: IndexedStack(
                    index: currentPageIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          );
        },
      );
}
