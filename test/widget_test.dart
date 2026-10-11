import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/search_source.dart';
import 'package:love_search_padi/models/video.dart';
import 'package:love_search_padi/services/movie_api.dart';
import 'package:love_search_padi/widgets/video_search_sheet.dart';

class ControlledMovieApi extends MovieApi {
  final requests = <Completer<VideoResponse>>[];
  final sources = <SearchSource>[];

  @override
  Future<VideoResponse> searchVideos(
    SearchSource source,
    String keyword, {
    CancelToken? cancelToken,
  }) {
    sources.add(source);
    final request = Completer<VideoResponse>();
    requests.add(request);
    return request.future;
  }
}

Widget searchApp(ControlledMovieApi api) => MaterialApp(
      home: Scaffold(
        body: VideoSearchSheet(
          api: api,
          sources: const [
            SearchSource(name: '来源一', url: 'https://one.example/api'),
            SearchSource(name: '来源二', url: 'https://two.example/api'),
          ],
          keyword: '',
        ),
      ),
    );

void main() {
  testWidgets('空关键词不会发起请求', (tester) async {
    final api = ControlledMovieApi();
    await tester.pumpWidget(searchApp(api));
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    expect(find.text('输入不能为空'), findsOneWidget);
    expect(api.requests, isEmpty);
  });

  testWidgets('搜索失败后结束加载，并可以重试', (tester) async {
    final api = ControlledMovieApi();
    await tester.pumpWidget(searchApp(api));
    await tester.enterText(find.byType(TextField), '电影');
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    api.requests.single.completeError(const FormatException('无效 JSON'));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('搜索失败'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    expect(api.requests, hasLength(2));
    api.requests.last.complete(VideoResponse(videos: []));
    await tester.pumpAndSettle();
    expect(find.text('未找到相关影片'), findsOneWidget);
  });

  testWidgets('切换来源后，旧请求的结果不会覆盖当前来源', (tester) async {
    final api = ControlledMovieApi();
    await tester.pumpWidget(searchApp(api));
    await tester.enterText(find.byType(TextField), '电影');
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    await tester.tap(find.text('来源二'));
    await tester.pumpAndSettle();
    api.requests.first.complete(VideoResponse(videos: [
      const Video(id: '1', name: '旧请求影片'),
    ]));
    await tester.pumpAndSettle();
    expect(find.text('旧请求影片'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    expect(api.sources.last.name, '来源二');
    api.requests.last.complete(VideoResponse(videos: []));
    await tester.pumpAndSettle();
    expect(find.text('未找到相关影片'), findsOneWidget);
  });

  testWidgets('关闭搜索页面后，请求完成不会更新已销毁的页面', (tester) async {
    final api = ControlledMovieApi();
    await tester.pumpWidget(searchApp(api));
    await tester.enterText(find.byType(TextField), '电影');
    await tester.tap(find.widgetWithText(FilledButton, '搜索'));
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    api.requests.single.complete(VideoResponse(videos: []));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
