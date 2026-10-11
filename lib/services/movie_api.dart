import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html;

import '../models/json_value.dart';
import '../models/movie_summary.dart';
import '../models/saved_video.dart';
import '../models/search_source.dart';
import '../models/video.dart';
import 'api_client.dart';

class MovieApi {
  static final instance = MovieApi();

  final ApiClient _client;

  MovieApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<SearchSource>> getSearchSources({CancelToken? cancelToken}) =>
      _client.getJson(
        'https://gitee.com/padi/padi/raw/master/lovesearch.json',
        cancelToken: cancelToken,
        fromJson: (json) =>
            jsonObjects(json).map(SearchSource.fromJson).toList(),
      );

  Future<List<MovieSummary>> getHotMovies({CancelToken? cancelToken}) =>
      _client.getJson(
        'https://movie.douban.com/j/search_subjects',
        queryParameters: {
          'type': 'movie',
          'sort': 'recommend',
          'tag': '热门',
          'page_limit': 100,
          'page_start': 1,
        },
        cancelToken: cancelToken,
        fromJson: (json) => jsonObjects(jsonObject(json)['subjects'])
            .map(MovieSummary.fromJson)
            .toList(),
      );

  Future<List<MovieSummary>> getTopMovies({CancelToken? cancelToken}) async {
    final body = await _client.getText(
      'https://movie.douban.com/top250',
      cancelToken: cancelToken,
    );
    final movies = <MovieSummary>[];
    for (final item in html.parse(body).querySelectorAll('.grid_view .item')) {
      final title = item.querySelector('.info .hd span')?.text;
      final cover = item.querySelector('.pic img')?.attributes['src'];
      if (title == null || cover == null) continue;
      movies.add(MovieSummary(
        title: title,
        cover: cover,
        rating: item.querySelector('.rating_num')?.text ?? '',
      ));
    }
    return movies;
  }

  Future<List<MovieSummary>> getUpcomingMovies(
      {CancelToken? cancelToken}) async {
    final body = await _client.getText(
      'https://movie.douban.com/cinema/later/',
      cancelToken: cancelToken,
    );
    final movies = <MovieSummary>[];
    for (final item in html.parse(body).querySelectorAll('.item')) {
      final title = item.querySelector('h3')?.text;
      final cover = item.querySelector('img')?.attributes['src'];
      if (title == null || cover == null) continue;
      movies.add(MovieSummary(
        title: title.replaceAll(RegExp(r'\s+'), ''),
        cover: cover,
        releaseDate: item.querySelector('.dt')?.text ?? '',
      ));
    }
    return movies;
  }

  Future<VideoResponse> searchVideos(
    SearchSource source,
    String keyword, {
    CancelToken? cancelToken,
  }) =>
      _client.getJson(
        source.url,
        queryParameters: VideoRequest.search(keyword).toJson(),
        cancelToken: cancelToken,
        fromJson: (json) => VideoResponse.fromJson(jsonObject(json)),
      );

  Future<Video> getSavedVideo(
    SavedVideo savedVideo, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.getJson(
      savedVideo.url,
      cancelToken: cancelToken,
      fromJson: (json) => VideoResponse.fromJson(jsonObject(json)),
    );
    if (response.videos.isEmpty) {
      throw const FormatException('未找到影片详情');
    }
    final id = Uri.parse(savedVideo.url).queryParameters['ids'];
    return response.videos.firstWhere(
      (video) => video.id == id,
      orElse: () => response.videos.first,
    );
  }
}
