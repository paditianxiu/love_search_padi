import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_search_padi/models/saved_video.dart';
import 'package:love_search_padi/models/search_source.dart';
import 'package:love_search_padi/services/api_client.dart';
import 'package:love_search_padi/services/movie_api.dart';

import 'support/stub_http_adapter.dart';

MovieApi apiWith(StubHttpAdapter adapter) =>
    MovieApi(client: ApiClient(dio: Dio()..httpClientAdapter = adapter));

ResponseBody body(Object json, {String contentType = 'application/json'}) =>
    ResponseBody.fromString(jsonEncode(json), 200, headers: {
      Headers.contentTypeHeader: [contentType],
    });

void main() {
  for (final contentType in ['application/json', 'text/plain']) {
    test('接口响应使用 $contentType 时均可反序列化', () async {
      final adapter = StubHttpAdapter((options) => body({
            'list': [
              {'vod_id': 1, 'vod_name': '电影', 'vod_year': 2026},
            ],
          }, contentType: contentType));
      final response = await apiWith(adapter).searchVideos(
        const SearchSource(name: '资源站', url: 'https://example.com/api'),
        '电影',
      );
      expect(response.videos.single.name, '电影');
      expect(response.videos.single.year, '2026');
    });
  }

  test('搜索参数统一编码，保留来源地址的已有参数', () async {
    final adapter = StubHttpAdapter((options) => body({'list': []}));
    await apiWith(adapter).searchVideos(
      const SearchSource(
        name: '资源站',
        url: 'https://example.com/api?token=abc',
      ),
      '中文 & 空格?',
    );
    expect(adapter.requests.single.uri.queryParameters, {
      'token': 'abc',
      'ac': 'detail',
      'wd': '中文 & 空格?',
    });
  });

  test('搜索源和热门影片都返回模型', () async {
    final adapter = StubHttpAdapter((options) {
      if (options.uri.host == 'gitee.com') {
        return body([
          {'name': '资源', 'url': 'https://example.com/api', 'push': 'true'},
        ]);
      }
      return body({
        'subjects': [
          {'title': '电影', 'cover': 'cover', 'rate': 9}
        ]
      });
    });
    final api = apiWith(adapter);
    expect((await api.getSearchSources()).single.openExternally, isTrue);
    expect((await api.getHotMovies()).single.rating, '9');
    expect(adapter.requests.last.uri.queryParameters['tag'], '热门');
  });

  test('HTML 接口在请求层转换成影片模型，跳过不完整条目', () async {
    final adapter = StubHttpAdapter((options) => ResponseBody.fromString(
          options.uri.path == '/top250'
              ? '<div class="grid_view"><div class="item"><div class="info"><div class="hd"><span>排行电影</span></div><span class="rating_num">9.5</span></div><div class="pic"><img src="top.jpg"></div></div><div class="item"></div></div>'
              : '<div class="item"><img src="later.jpg"><h3> 即将\n上映 </h3><span class="dt">10月10日</span></div><div class="item"></div>',
          200,
        ));
    final api = apiWith(adapter);
    final top = (await api.getTopMovies()).single;
    expect(top.title, '排行电影');
    expect(top.rating, '9.5');
    final upcoming = (await api.getUpcomingMovies()).single;
    expect(upcoming.title, '即将上映');
    expect(upcoming.releaseDate, '10月10日');
  });

  test('收藏详情按影视 ID 选择影片，空列表提供明确错误', () async {
    final adapter = StubHttpAdapter((options) => body({
          'list': options.uri.queryParameters['ids'] == '2'
              ? [
                  {'vod_id': 1, 'vod_name': '第一部'},
                  {'vod_id': 2, 'vod_name': '第二部'},
                ]
              : [],
        }));
    final api = apiWith(adapter);
    expect(
      (await api.getSavedVideo(const SavedVideo(
        url: 'https://example.com/api?ac=detail&ids=2',
        name: '第二部',
        imageUrl: '',
      )))
          .name,
      '第二部',
    );
    await expectLater(
      api.getSavedVideo(const SavedVideo(
        url: 'https://example.com/api?ac=detail&ids=3',
        name: '已删除',
        imageUrl: '',
      )),
      throwsFormatException,
    );
  });

  test('HTTP 失败和无效 JSON 不会变成空的成功结果', () async {
    final errorApi = apiWith(StubHttpAdapter(
      (options) => ResponseBody.fromString('unavailable', 503),
    ));
    await expectLater(
        errorApi.getSearchSources(), throwsA(isA<DioException>()));
    final invalidApi = apiWith(StubHttpAdapter(
      (options) => ResponseBody.fromString('<html>error</html>', 200),
    ));
    await expectLater(invalidApi.getSearchSources(), throwsFormatException);
  });

  test('已经取消的请求不访问网络', () async {
    final adapter = StubHttpAdapter((options) => body([]));
    final token = CancelToken()..cancel();
    await expectLater(
      apiWith(adapter).getSearchSources(cancelToken: token),
      throwsA(isA<DioException>().having(
        (error) => error.type,
        'type',
        DioExceptionType.cancel,
      )),
    );
    expect(adapter.requests, isEmpty);
  });
}
