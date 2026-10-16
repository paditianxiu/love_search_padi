// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/movie_summary.dart';
import '../../models/search_source.dart';
import '../../services/movie_api.dart';
import '../../widgets/video_search_sheet.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/app_layout.dart';
import '../../widgets/responsive_movie_grid.dart';

class HomePage extends StatefulWidget {
  final MovieApi? api;

  const HomePage({super.key, this.api});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final MovieApi _api = widget.api ?? MovieApi.instance;
  final CancelToken _cancelToken = CancelToken();
  List<SearchSource> sources = [];
  List<MovieSummary> hotMovies = [];
  List<MovieSummary> topMovies = [];
  List<MovieSummary> upcomingMovies = [];
  final List<bool> _loading = [true, true, true];
  final List<String?> _errors = [null, null, null];
  String? _sourceError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    getSearchData();
    for (var index = 0; index < 3; index++) {
      _loadMovies(index);
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMovies(int index) async {
    setState(() {
      _loading[index] = true;
      _errors[index] = null;
    });
    try {
      final List<MovieSummary> movies;
      switch (index) {
        case 0:
          movies = await _api.getHotMovies(cancelToken: _cancelToken);
        case 1:
          movies = await _api.getTopMovies(cancelToken: _cancelToken);
        default:
          movies = await _api.getUpcomingMovies(cancelToken: _cancelToken);
      }
      if (!mounted) return;
      setState(() {
        switch (index) {
          case 0:
            hotMovies = movies;
          case 1:
            topMovies = movies;
          default:
            upcomingMovies = movies;
        }
      });
    } catch (error) {
      if (mounted) setState(() => _errors[index] = '加载失败：$error');
    } finally {
      if (mounted) setState(() => _loading[index] = false);
    }
  }

  Future<void> getSearchData() async {
    try {
      final result = await _api.getSearchSources(cancelToken: _cancelToken);
      debugPrint(result.map((source) => source.toJson()).toList().toString());
      if (!mounted) return;
      setState(() {
        sources = result;
        _sourceError = result.isEmpty ? '暂时没有可用的搜索源' : null;
      });
    } catch (error) {
      if (mounted) setState(() => _sourceError = '搜索源加载失败：$error');
    }
  }

  Widget _emptyState(int index) {
    if (_loading[index]) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_errors[index] ?? '暂无影片'),
          if (_errors[index] != null)
            TextButton(
              onPressed: () => _loadMovies(index),
              child: const Text('重试'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('爱搜片'),
          actions: [
            IconButton(
                onPressed: () {
                  if (sources.isNotEmpty) {
                    showSearchDialog("");
                  } else {
                    final context = this.context;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('提示'),
                          content: Text(_sourceError ?? '搜索源正在初始化，请稍后...'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('确定'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.search)),
            const SizedBox(width: 10)
          ],
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.whatshot),
                      Text('热门推荐'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_outline),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text('豆瓣排行'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note),
                      Text('即将上映'),
                    ],
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMovies(0, hotMovies),
            _buildMovies(1, topMovies),
            _buildMovies(2, upcomingMovies),
          ],
        ));
  }

  Widget _buildMovies(int tab, List<MovieSummary> movies) {
    if (movies.isEmpty) return _emptyState(tab);
    return ResponsiveMovieGrid(
      key: PageStorageKey('home-movies-$tab'),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return buildGridItem(
          movie.title,
          movie.cover,
          tab == 0
              ? movie.rating
              : tab == 1
                  ? 'No.${index + 1}'
                  : movie.releaseDate,
        );
      },
    );
  }

  void showSearchDialog(String keyword) {
    if (sources.isEmpty) return;
    final size = MediaQuery.sizeOf(context);
    final search = VideoSearchSheet(
      api: _api,
      sources: sources,
      keyword: keyword,
    );
    if (size.width >= AppLayout.navigationBreakpoint) {
      showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 1200,
            height: (size.height * 0.85).clamp(0.0, 900.0),
            child: search,
          ),
        ),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        builder: (context) => search,
      );
    }
  }

  Widget buildGridItem(String title, String imgUrl, String label) => MovieCard(
        title: title,
        imageUrl: imgUrl,
        label: label,
        onTap: () => showSearchDialog(title),
      );
}
