import 'json_value.dart';

class Video {
  final String id;
  final String name;
  final String picture;
  final String category;
  final String playUrl;
  final String content;
  final String year;
  final String area;
  final String updatedAt;

  const Video({
    required this.id,
    required this.name,
    this.picture = '',
    this.category = '',
    this.playUrl = '',
    this.content = '',
    this.year = '',
    this.area = '',
    this.updatedAt = '',
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: jsonString(json['vod_id']),
        name: jsonString(json['vod_name']),
        picture: jsonString(json['vod_pic']),
        category: jsonString(json['vod_class']),
        playUrl: jsonString(json['vod_play_url']),
        content: jsonString(json['vod_content']),
        year: jsonString(json['vod_year']),
        area: jsonString(json['vod_area']),
        updatedAt: jsonString(json['vod_time']),
      );

  Map<String, dynamic> toJson() => {
        'vod_id': id,
        'vod_name': name,
        'vod_pic': picture,
        'vod_class': category,
        'vod_play_url': playUrl,
        'vod_content': content,
        'vod_year': year,
        'vod_area': area,
        'vod_time': updatedAt,
      };

  String get subtitle => [year, area, category, updatedAt].join(' / ');

  List<String> get playbackUrls {
    final sources = playUrl.split('\$\$\$');
    // 保留原有的播放源选择规则：多个源时使用第二个。
    final episodes = (sources.length > 1 ? sources[1] : sources[0]).split('#');
    return episodes
        .where((episode) => episode.contains('\$'))
        .map((episode) => episode.substring(episode.indexOf('\$') + 1).trim())
        .where((url) => url.isNotEmpty)
        .toList();
  }
}

class VideoResponse {
  final List<Video> videos;

  VideoResponse({required List<Video> videos})
      : videos = List.unmodifiable(videos);

  factory VideoResponse.fromJson(Map<String, dynamic> json) => VideoResponse(
        videos: jsonObjects(json['list']).map(Video.fromJson).toList(),
      );

  Map<String, dynamic> toJson() => {
        'list': videos.map((video) => video.toJson()).toList(),
      };
}

class VideoRequest {
  final String? keyword;
  final String? id;

  const VideoRequest.search(String this.keyword) : id = null;
  const VideoRequest.detail(String this.id) : keyword = null;

  Map<String, dynamic> toJson() => {
        'ac': 'detail',
        if (keyword != null) 'wd': keyword,
        if (id != null) 'ids': id,
      };
}
