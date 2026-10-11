import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/json_value.dart';
import 'package:love_search_padi/models/movie_summary.dart';
import 'package:love_search_padi/models/saved_video.dart';
import 'package:love_search_padi/models/search_source.dart';
import 'package:love_search_padi/models/video.dart';

void main() {
  test('JSON 字符串和已经解码的数据使用相同的解析入口', () {
    expect(jsonObject('{"list":[]}'), {'list': []});
    expect(jsonObject({'list': []}), {'list': []});
    expect(jsonObjects('[{"name":"资源"}]'), [
      {'name': '资源'}
    ]);
    expect(() => jsonObject('[]'), throwsFormatException);
    expect(() => jsonObjects({'error': '请求失败'}), throwsFormatException);
    expect(() => jsonObjects([1]), throwsFormatException);
  });

  test('搜索源兼容布尔值和字符串，并支持 JSON 往返', () {
    for (final push in [true, 'true', false, 'false', null]) {
      final source = SearchSource.fromJson({
        'name': '资源站',
        'url': 'https://example.com/api',
        'push': push,
      });
      expect(source.openExternally, push == true || push == 'true');
      expect(SearchSource.fromJson(source.toJson()).toJson(), source.toJson());
    }
  });

  test('影视详情兼容数字和空值字段，并支持 JSON 往返', () {
    final video = Video.fromJson({
      'vod_id': 123,
      'vod_name': '测试电影',
      'vod_year': 2026,
      'vod_area': '中国',
      'vod_class': null,
      'vod_pic': null,
    });
    expect(video.id, '123');
    expect(video.year, '2026');
    expect(video.picture, '');
    expect(video.category, '');
    expect(video.subtitle, '2026 / 中国 /  / ');
    expect(Video.fromJson(video.toJson()).toJson(), video.toJson());
    final response = VideoResponse.fromJson({
      'list': [video.toJson()]
    });
    expect(VideoResponse.fromJson(response.toJson()).videos.single.id, '123');
    expect(() => VideoResponse.fromJson({}), throwsFormatException);
  });

  test('豆瓣评分支持数字和缺省字段', () {
    final movie = MovieSummary.fromJson({'title': '电影', 'rate': 8.5});
    expect(movie.rating, '8.5');
    expect(movie.cover, '');
    expect(MovieSummary.fromJson(movie.toJson()).toJson(), movie.toJson());
  });

  test('播放地址保留原有播放源规则，不依赖尾部井号', () {
    const video = Video(
      id: '1',
      name: '电影',
      playUrl: '正片\$https://example.com/a.m3u8',
    );
    expect(video.playbackUrls, ['https://example.com/a.m3u8']);
    final multiSource = Video.fromJson({
      'vod_play_url':
          '正片\$https://example.com/a.mp4\$\$\$第1集\$https://example.com/1.m3u8#第2集\$https://example.com/2.m3u8#无效\$#',
    });
    expect(multiSource.playbackUrls, [
      'https://example.com/1.m3u8',
      'https://example.com/2.m3u8',
    ]);
    expect(const Video(id: '', name: '').playbackUrls, isEmpty);
  });

  test('旧收藏记录可读取，详情链接保留搜索源原有参数', () {
    final old = SavedVideo.decode(
      '{"url":"https://example.com/api?ac=detail&ids=123","name":"电影","imgUrl":"cover.jpg"}',
    );
    expect(old.name, '电影');
    expect(old.imageUrl, 'cover.jpg');
    expect(Uri.parse(old.resourceUrl).path, '/api');
    expect(Uri.parse(old.resourceUrl).queryParameters, isEmpty);
    expect(SavedVideo.decode(old.encode()).toJson(), old.toJson());

    final saved = SavedVideo.fromVideo(
      const Video(id: '中文 & 1', name: '电影'),
      'https://example.com/api?token=abc&tag=a&tag=b&wd=old#anchor',
    );
    final uri = Uri.parse(saved.url);
    expect(uri.queryParameters['token'], 'abc');
    expect(uri.queryParametersAll['tag'], ['a', 'b']);
    expect(uri.queryParameters['ids'], '中文 & 1');
    expect(uri.queryParameters.containsKey('wd'), isFalse);
    expect(uri.fragment, 'anchor');
    expect(Uri.parse(saved.resourceUrl).queryParametersAll, {
      'token': ['abc'],
      'tag': ['a', 'b'],
    });
  });
}
