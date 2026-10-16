import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/search_source.dart';
import '../models/video.dart';
import '../pages/player/player.dart';
import '../services/movie_api.dart';
import 'movie_card.dart';
import 'responsive_movie_grid.dart';

class VideoSearchSheet extends StatefulWidget {
  final MovieApi api;
  final List<SearchSource> sources;
  final String keyword;

  const VideoSearchSheet({
    super.key,
    required this.api,
    required this.sources,
    required this.keyword,
  });

  @override
  State<VideoSearchSheet> createState() => _VideoSearchSheetState();
}

class _VideoSearchSheetState extends State<VideoSearchSheet> {
  late final TextEditingController _textController;
  final _sourceScrollController = ScrollController();
  int _selectedSourceIndex = 0;
  CancelToken? _cancelToken;
  List<Video> _videos = [];
  SearchSource? _resultSource;
  bool _loading = false;
  bool _searched = false;
  String? _error;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.keyword);
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    _textController.dispose();
    _sourceScrollController.dispose();
    super.dispose();
  }

  void _changeSource(int index) {
    if (index == _selectedSourceIndex) return;
    _cancelToken?.cancel();
    _requestId++;
    setState(() {
      _selectedSourceIndex = index;
      _videos = [];
      _loading = false;
      _searched = false;
      _error = null;
    });
  }

  Future<void> _search() async {
    final keyword = _textController.text.trim();
    if (keyword.isEmpty) {
      setState(() => _error = '输入不能为空');
      return;
    }
    FocusScope.of(context).unfocus();
    final source = widget.sources[_selectedSourceIndex];
    _cancelToken?.cancel();
    final requestId = ++_requestId;
    final cancelToken = _cancelToken = CancelToken();
    setState(() {
      _loading = true;
      _searched = true;
      _error = null;
      _videos = [];
    });
    try {
      if (source.openExternally) {
        if (!await launchUrl(Uri.parse(source.url))) {
          throw const FormatException('无法打开搜索源');
        }
      } else {
        final response = await widget.api.searchVideos(
          source,
          keyword,
          cancelToken: cancelToken,
        );
        if (!mounted || requestId != _requestId) return;
        setState(() {
          _videos = response.videos;
          _resultSource = source;
        });
      }
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() => _error = '搜索失败：$error');
    } finally {
      if (mounted && requestId == _requestId) {
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildSourceTabs() {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      child: Scrollbar(
        controller: _sourceScrollController,
        child: ListView.builder(
          controller: _sourceScrollController,
          primary: false,
          padding: const EdgeInsets.all(8),
          itemCount: widget.sources.length,
          itemBuilder: (context, index) {
            final source = widget.sources[index];
            final selected = index == _selectedSourceIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Tooltip(
                message: source.name,
                child: ListTile(
                  selected: selected,
                  selectedTileColor: colors.secondaryContainer,
                  selectedColor: colors.onSecondaryContainer,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  minVerticalPadding: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    source.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () => _changeSource(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_videos.isEmpty) {
      return Center(child: Text(_searched ? '未找到相关影片' : '请输入关键词搜索'));
    }
    return ResponsiveMovieGrid(
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return MovieCard(
          title: video.name,
          imageUrl: video.picture,
          label: video.category,
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => VideoScreen(
              video: video,
              resourceUrl: _resultSource!.url,
            ),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: '关闭',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _search(),
                      decoration: const InputDecoration(
                        labelText: '输入搜索的关键词...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _loading ? null : _search,
                    icon: const Icon(Icons.search),
                    label: const Text('搜索'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    SizedBox(
                      width: (constraints.maxWidth * 0.25).clamp(96.0, 160.0),
                      child: _buildSourceTabs(),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: _buildResults()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
