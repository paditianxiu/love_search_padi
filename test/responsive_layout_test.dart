import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/movie_summary.dart';
import 'package:love_search_padi/models/search_source.dart';
import 'package:love_search_padi/pages/MainPage.dart';
import 'package:love_search_padi/pages/home/ClassificationPage.dart';
import 'package:love_search_padi/pages/home/HomePage.dart';
import 'package:love_search_padi/services/movie_api.dart';
import 'package:love_search_padi/widgets/playback_layout.dart';
import 'package:love_search_padi/widgets/responsive_movie_grid.dart';
import 'package:love_search_padi/widgets/video_search_sheet.dart';

void setWindow(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

class FixtureMovieApi extends MovieApi {
  @override
  Future<List<SearchSource>> getSearchSources(
          {CancelToken? cancelToken}) async =>
      const [SearchSource(name: '来源一', url: 'https://example.com/api')];

  @override
  Future<List<MovieSummary>> getHotMovies({CancelToken? cancelToken}) async =>
      [];

  @override
  Future<List<MovieSummary>> getTopMovies({CancelToken? cancelToken}) async =>
      [];

  @override
  Future<List<MovieSummary>> getUpcomingMovies(
          {CancelToken? cancelToken}) async =>
      [];
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int value = 0;

  @override
  Widget build(BuildContext context) => Center(
        child: FilledButton(
          onPressed: () => setState(() => value++),
          child: Text('计数：$value'),
        ),
      );
}

Widget playbackApp() => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('示例影片')),
        body: RepaintBoundary(
          key: const ValueKey('playback-preview'),
          child: PlaybackLayout(
            player: const ColoredBox(
              key: ValueKey('video-area'),
              color: Color(0xff17212b),
              child: Center(
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white70, size: 64),
              ),
            ),
            information: Column(
              key: const ValueKey('video-information'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('示例影片',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('2026 / 中国 / 剧情'),
                const SizedBox(height: 8),
                Text('影片简介。' * 40),
              ],
            ),
            episodeCount: 80,
            episodeBuilder: (context, index) => OutlinedButton(
              onPressed: () {},
              child: Text('第${index + 1}集'),
            ),
          ),
        ),
      ),
    );

Future<void> capturePreview(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('CAPTURE_LAYOUT_PREVIEWS')) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('playback-preview')));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('build/layout_previews/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(data!.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  });
}

void main() {
  testWidgets('宽屏使用侧栏，缩小窗口后保留当前页面和页面状态', (tester) async {
    setWindow(tester, const Size(1366, 768));
    await tester.pumpWidget(const MaterialApp(
      home: MainPage(pages: [CounterPage(), CounterPage(), CounterPage()]),
    ));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.text('分类'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('计数：0'));
    await tester.pumpAndSettle();
    expect(find.text('计数：1'), findsOneWidget);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1);
    expect(find.text('计数：1'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('计数：1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('2K 屏幕海报网格居中，卡片保持可读尺寸且可以滚动', (tester) async {
    setWindow(tester, const Size(2560, 1440));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ResponsiveMovieGrid(
          itemCount: 100,
          itemBuilder: (context, index) => ColoredBox(
            key: ValueKey('poster-$index'),
            color: Colors.green,
            child: Center(child: Text('影片 $index')),
          ),
        ),
      ),
    ));
    final first = find.byKey(const ValueKey('poster-0'));
    final size = tester.getSize(first);
    expect(size.width, inInclusiveRange(180, 240));
    expect(size.height, greaterThan(280));
    expect(tester.getTopLeft(first).dx, greaterThan(500));
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('poster-99')),
      800,
      scrollable: find.byType(Scrollable),
    );
    expect(find.byKey(const ValueKey('poster-99')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('网格按实际内容宽度排版，不使用整窗宽度', (tester) async {
    setWindow(tester, const Size(1920, 1080));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 390,
              child: ResponsiveMovieGrid(
                itemCount: 10,
                itemBuilder: (context, index) => SizedBox(
                  key: ValueKey('narrow-poster-$index'),
                  child: Text('影片 $index'),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
    final first = find.byKey(const ValueKey('narrow-poster-0'));
    expect(tester.getSize(first).width, inInclusiveRange(140, 190));
    expect(tester.getTopLeft(find.byKey(const ValueKey('narrow-poster-1'))).dy,
        tester.getTopLeft(first).dy);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 480),
    const Size(390, 844),
    const Size(800, 600),
    const Size(1280, 720),
    const Size(1920, 1080),
    const Size(2560, 1440),
    const Size(1280, 400),
  ]) {
    testWidgets('播放布局在 ${size.width} × ${size.height} 不溢出', (tester) async {
      setWindow(tester, size);
      await tester.pumpWidget(playbackApp());
      await tester.pumpAndSettle();
      final video = find.byKey(const ValueKey('video-area'));
      final videoSize = tester.getSize(video);
      expect(videoSize.width / videoSize.height, closeTo(16 / 9, 0.01));
      if (size.width >= 1100 && size.height >= 720) {
        expect(find.byType(GridView), findsOneWidget);
        expect(tester.getTopLeft(find.byType(GridView)).dx,
            greaterThan(tester.getTopRight(video).dx));
      } else {
        expect(find.byType(CustomScrollView), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      if (size == const Size(1920, 1080)) {
        await capturePreview(tester, 'desktop_playback');
      } else if (size == const Size(390, 844)) {
        await capturePreview(tester, 'mobile_playback');
      }
    });
  }

  testWidgets('桌面选集可以独立滚动到底，播放器位置保持不变', (tester) async {
    setWindow(tester, const Size(1366, 768));
    await tester.pumpWidget(playbackApp());
    final video = find.byKey(const ValueKey('video-area'));
    final position = tester.getTopLeft(video);
    await tester.scrollUntilVisible(
      find.text('第80集'),
      500,
      scrollable: find.descendant(
        of: find.byType(GridView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('第80集'), findsOneWidget);
    expect(tester.getTopLeft(video), position);
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(390, 844), const Size(1920, 1080)]) {
    testWidgets('搜索在 $size 使用适合窗口尺寸的容器', (tester) async {
      setWindow(tester, size);
      await tester
          .pumpWidget(MaterialApp(home: HomePage(api: FixtureMovieApi())));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.byType(VideoSearchSheet), findsOneWidget);
      if (size.width >= 900) {
        expect(find.byType(Dialog), findsOneWidget);
        expect(tester.getSize(find.byType(VideoSearchSheet)).width,
            lessThanOrEqualTo(1200));
      } else {
        expect(find.byType(BottomSheet), findsOneWidget);
      }
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(find.byType(VideoSearchSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(320, 400), const Size(1366, 768)]) {
    testWidgets('分类筛选在 $size 能滚动且不会溢出', (tester) async {
      setWindow(tester, size);
      await tester.pumpWidget(const MaterialApp(home: ClassificationPage()));
      await tester.pumpAndSettle();
      expect(find.text('类型'), findsOneWidget);
      if (size.width >= 900) {
        expect(find.byType(Wrap), findsNWidgets(5));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
