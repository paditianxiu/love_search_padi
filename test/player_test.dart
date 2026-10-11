import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/saved_video.dart';
import 'package:love_search_padi/models/video.dart' as models;
import 'package:love_search_padi/pages/player/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('空播放列表进入和关闭页面都不创建原生播放器', (tester) async {
    final fijkCalls = <String>[];
    const channel = MethodChannel('befovy.com/fijk');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async {
        fijkCalls.add(call.method);
        throw MissingPluginException('此平台没有 fijkplayer');
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));

    await tester.pumpWidget(const MaterialApp(
      home: VideoScreen(
        video: models.Video(id: '1', name: '空播放列表'),
        resourceUrl: 'https://example.com/api',
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('暂无可播放的剧集'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();
    expect(fijkCalls, isEmpty);
    expect(tester.takeException(), isNull);

    final preferences = await SharedPreferences.getInstance();
    final history = preferences.getStringList('历史记录')!;
    expect(SavedVideo.decode(history.single).name, '空播放列表');
  });

  testWidgets('收藏按钮沿用旧记录，可取消和重新收藏', (tester) async {
    const saved = SavedVideo(
      url: 'https://example.com/api?ac=detail&ids=1',
      name: '电影',
      imageUrl: 'cover.jpg',
    );
    SharedPreferences.setMockInitialValues({
      '影视收藏': [saved.encode()],
    });
    var changes = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FavoriteToggleIconButton(
          video: saved,
          onStateChanged: () => changes++,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('影视收藏'), isEmpty);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(preferences.getStringList('影视收藏'), [saved.encode()]);
    expect(changes, 2);
  });
}
