import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_video.dart';

class VideoLibrary {
  static const favoritesKey = '影视收藏';
  static const historyKey = '历史记录';

  Future<List<SavedVideo>> loadFavorites() => _load(favoritesKey);
  Future<List<SavedVideo>> loadHistory() => _load(historyKey);

  Future<List<SavedVideo>> _load(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getStringList(key) ?? [])
        .map(SavedVideo.decode)
        .toList();
  }

  Future<void> _save(String key, List<SavedVideo> videos) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      key,
      videos.map((video) => video.encode()).toList(),
    );
  }

  Future<void> setFavorite(SavedVideo video, bool isFavorite) async {
    final videos = await loadFavorites();
    videos.removeWhere((item) => item.url == video.url);
    if (isFavorite) videos.add(video);
    await _save(favoritesKey, videos);
  }

  Future<void> recordHistory(SavedVideo video) async {
    final videos = await loadHistory();
    videos.removeWhere((item) => item.url == video.url);
    videos.add(video);
    await _save(historyKey, videos);
  }

  Future<void> clearHistory() => _save(historyKey, []);
}
