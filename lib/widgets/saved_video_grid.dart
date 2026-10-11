import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/saved_video.dart';
import '../models/video.dart';
import '../pages/player/main.dart';
import '../services/movie_api.dart';
import 'movie_card.dart';
import 'responsive_movie_grid.dart';

class SavedVideoGrid extends StatefulWidget {
  final List<SavedVideo> videos;
  final Future<void> Function() onReturn;
  final MovieApi? api;

  const SavedVideoGrid({
    super.key,
    required this.videos,
    required this.onReturn,
    this.api,
  });

  @override
  State<SavedVideoGrid> createState() => _SavedVideoGridState();
}

class _SavedVideoGridState extends State<SavedVideoGrid> {
  CancelToken? _cancelToken;
  bool _opening = false;
  DialogRoute<void>? _loadingRoute;
  NavigatorState? _navigator;

  @override
  void dispose() {
    _cancelToken?.cancel();
    final route = _loadingRoute;
    final navigator = _navigator;
    if (route != null && navigator != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator.mounted && route.isActive) navigator.removeRoute(route);
      });
    }
    super.dispose();
  }

  Future<void> _open(SavedVideo savedVideo) async {
    if (_opening) return;
    _opening = true;
    final cancelToken = _cancelToken = CancelToken();
    final navigator = _navigator = Navigator.of(context, rootNavigator: true);
    final route = _loadingRoute = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 26),
                child: Text('正在加载，请稍后...'),
              ),
            ],
          ),
        ),
      ),
    );
    navigator.push(route);
    Video? video;
    Object? failure;
    try {
      video = await (widget.api ?? MovieApi.instance).getSavedVideo(
        savedVideo,
        cancelToken: cancelToken,
      );
    } catch (error) {
      failure = error;
    } finally {
      if (navigator.mounted && route.isActive) navigator.removeRoute(route);
      _loadingRoute = null;
      _opening = false;
    }
    if (!mounted) return;
    if (failure != null) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('错误'),
          content: Text('加载失败：$failure'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }
    final selectedVideo = video!;
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => VideoScreen(
        video: selectedVideo,
        resourceUrl: savedVideo.resourceUrl,
      ),
    ));
    if (mounted) await widget.onReturn();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videos.isEmpty) {
      return Center(
        child: Image.asset('assets/images/null.png', height: 200, width: 200),
      );
    }
    return ResponsiveMovieGrid(
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final video = widget.videos[index];
        return MovieCard(
          title: video.name,
          imageUrl: video.imageUrl,
          onTap: () => _open(video),
        );
      },
    );
  }
}
