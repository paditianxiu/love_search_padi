import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/saved_video.dart';
import 'package:love_search_padi/services/video_library.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const first = SavedVideo(
    url: 'https://example.com/api?ac=detail&ids=1',
    name: '电影一',
    imageUrl: 'one.jpg',
  );
  const second = SavedVideo(
    url: 'https://example.com/api?ac=detail&ids=2',
    name: '电影二',
    imageUrl: 'two.jpg',
  );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('收藏读取兼容旧格式，按链接识别记录，避免字段更新造成重复', () async {
    SharedPreferences.setMockInitialValues({
      VideoLibrary.favoritesKey: [
        '{"url":"https://example.com/api?ac=detail&ids=1","name":"旧标题","imgUrl":"old.jpg"}',
      ],
    });
    final library = VideoLibrary();
    expect((await library.loadFavorites()).single.name, '旧标题');
    await library.setFavorite(first, true);
    expect((await library.loadFavorites()).single.name, '电影一');
    await library.setFavorite(first, false);
    expect(await library.loadFavorites(), isEmpty);
  });

  test('历史重新观看会移动到最后，清空不会影响收藏', () async {
    final library = VideoLibrary();
    await library.setFavorite(first, true);
    await library.recordHistory(first);
    await library.recordHistory(second);
    await library.recordHistory(first);
    expect((await library.loadHistory()).map((video) => video.name), [
      '电影二',
      '电影一',
    ]);
    await library.clearHistory();
    expect(await library.loadHistory(), isEmpty);
    expect((await library.loadFavorites()).single.url, first.url);
  });
}
