// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

import '../../models/saved_video.dart';
import '../../models/video.dart' as models;
import '../../services/video_library.dart';
import '../../widgets/playback_layout.dart';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

//import 'package:wakelock/wakelock.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.
import 'dart:io' as io;

class FavoriteToggleIconButton extends StatefulWidget {
  final SavedVideo video;
  final Function() onStateChanged;

  const FavoriteToggleIconButton({
    super.key,
    required this.video,
    required this.onStateChanged,
  });

  @override
  _FavoriteToggleIconButtonState createState() =>
      _FavoriteToggleIconButtonState();
}

class _FavoriteToggleIconButtonState extends State<FavoriteToggleIconButton> {
  final _library = VideoLibrary();
  bool isFavorite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final videos = await _library.loadFavorites();
      if (!mounted) return;
      setState(() {
        isFavorite = videos.any((video) => video.url == widget.video.url);
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('收藏加载失败：$error')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _loading = true);
    try {
      await _library.setFavorite(widget.video, !isFavorite);
      if (!mounted) return;
      setState(() => isFavorite = !isFavorite);
      widget.onStateChanged();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('收藏保存失败：$error')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "收藏",
      icon: isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      onPressed: _loading ? null : _toggleFavorite,
    );
  }
}

class VideoScreen extends StatefulWidget {
  final models.Video video;
  final String resourceUrl;

  const VideoScreen(
      {super.key, required this.video, required this.resourceUrl});

  @override
  // ignore: library_private_types_in_public_api
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Player? player2;
  VideoController? controller;

  int currentCollection = 0;
  String localSpeed = 'X1.0';
  late final List<String> urlListNew;
  late final SavedVideo _savedVideo;
  FijkPlayer? player;

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    _savedVideo = SavedVideo.fromVideo(widget.video, widget.resourceUrl);
    urlListNew = widget.video.playbackUrls;
    if (urlListNew.isNotEmpty) {
      if (io.Platform.isAndroid) {
        player = FijkPlayer();
      } else {
        player2 = Player();
        controller = VideoController(player2!);
      }
      WakelockPlus.enable();
      _playEpisode(0);
    }
    setData();
  }

  @override
  void dispose() {
    player2?.dispose();
    player?.release();
    if (urlListNew.isNotEmpty) WakelockPlus.disable();
    super.dispose();
  }

  Future<void> setData() async {
    try {
      await VideoLibrary().recordHistory(_savedVideo);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('历史记录保存失败：$error')),
      );
    }
  }

  Future<void> _playEpisode(int index) async {
    if (io.Platform.isAndroid) {
      if (index != currentCollection) await player!.reset();
      if (!mounted) return;
      await player!.setDataSource(urlListNew[index], autoPlay: true);
    } else {
      await player2!.open(Media(urlListNew[index]));
    }
    if (mounted) setState(() => currentCollection = index);
  }

  @override
  Widget build(BuildContext context) {
    final brief = widget.video.content
        .replaceAll(" ", "")
        .replaceAll("<p>", "")
        .replaceAll("<br/>", "")
        .replaceAll("　", "")
        .replaceAll("</p>", "");

    final List<double> speedList = [
      0.5,
      1.0,
      1.5,
      2.0,
    ];
    final List<String> menuOptions = ['X0.5', 'X1.0', 'X1.5', 'X2.0'];
    return Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(tooltip: "倍数", onPressed: (){}, icon: Icon(Icons.speed)),
            PopupMenuButton(
              onSelected: (String result) {
                setState(() => localSpeed = result);
                if (io.Platform.isAndroid) {
                  player?.setSpeed(speedList[menuOptions.indexOf(result)]);
                } else {
                  player2?.setRate(speedList[menuOptions.indexOf(result)]);
                }
              },
              icon: const Icon(Icons.speed),
              itemBuilder: (BuildContext context) =>
                  menuOptions.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      localSpeed == choice
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColor)
                          : const Icon(null),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(choice)
                    ],
                  ),
                );
              }).toList(),
            ),
            FavoriteToggleIconButton(video: _savedVideo, onStateChanged: () {}),
            const SizedBox(width: 10)
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.video.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4.0),
              Text(
                "第${currentCollection + 1}集",
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
        body: PlaybackLayout(
          player: urlListNew.isEmpty
              ? const Center(
                  child: Text(
                    '暂无可播放的剧集',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : io.Platform.isAndroid
                  ? FijkView(color: Colors.black, player: player!)
                  : Video(controller: controller!),
          information: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.video.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                widget.video.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (brief.isNotEmpty) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('简介'),
                      content: SizedBox(
                        width: 560,
                        child: SingleChildScrollView(child: Text(brief)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    brief,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
          episodeCount: urlListNew.length,
          episodeBuilder: (context, index) => OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: currentCollection == index
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            icon: currentCollection == index
                ? const Icon(Icons.check, size: 16)
                : const SizedBox.shrink(),
            onPressed: () async {
              if (currentCollection != index) await _playEpisode(index);
            },
            label: Text(
              '第${index + 1}集',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
  }
}
