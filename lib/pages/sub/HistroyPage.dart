// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../models/saved_video.dart';
import '../../services/video_library.dart';
import '../../widgets/saved_video_grid.dart';

class HistroyPage extends StatefulWidget {
  const HistroyPage({super.key});

  @override
  State<HistroyPage> createState() => _HistroyPageState();
}

class _HistroyPageState extends State<HistroyPage> {
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
      final videos = await _library.loadHistory();
      if (!mounted) return;
      setState(() {
        _videos = videos.reversed.toList();
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = '历史记录加载失败：$error');
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('是否清空历史记录?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _library.clearHistory();
      if (mounted) {
        setState(() {
          _videos = [];
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = '清空历史记录失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('历史记录'),
          actions: [
            IconButton(
              tooltip: '清空历史记录',
              onPressed: _clearHistory,
              icon: const Icon(Icons.cleaning_services),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: _error != null
            ? Center(child: Text(_error!))
            : _videos == null
                ? const Center(child: CircularProgressIndicator())
                : SavedVideoGrid(videos: _videos!, onReturn: _load),
      );
}
