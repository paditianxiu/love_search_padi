// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../models/saved_video.dart';
import '../../services/video_library.dart';
import '../../widgets/saved_video_grid.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _library = VideoLibrary();
  List<SavedVideo>? _videos;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final videos = await _library.loadFavorites();
      if (!mounted) return;
      setState(() {
        _videos = videos.reversed.toList();
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = '收藏加载失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('收藏')),
        body: _error != null
            ? Center(child: Text(_error!))
            : _videos == null
                ? const Center(child: CircularProgressIndicator())
                : SavedVideoGrid(videos: _videos!, onReturn: _load),
      );
}
