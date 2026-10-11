import 'dart:convert';

import 'json_value.dart';
import 'video.dart';

class SavedVideo {
  final String url;
  final String name;
  final String imageUrl;

  const SavedVideo({
    required this.url,
    required this.name,
    required this.imageUrl,
  });

  factory SavedVideo.fromJson(Map<String, dynamic> json) => SavedVideo(
        url: jsonString(json['url']),
        name: jsonString(json['name']),
        imageUrl: jsonString(json['imgUrl']),
      );

  factory SavedVideo.fromVideo(Video video, String resourceUrl) {
    final uri = Uri.parse(resourceUrl);
    final parameters = Map<String, dynamic>.from(uri.queryParametersAll)
      ..remove('wd')
      ..addAll(VideoRequest.detail(video.id).toJson());
    return SavedVideo(
      url: uri.replace(queryParameters: parameters).toString(),
      name: video.name,
      imageUrl: video.picture,
    );
  }

  factory SavedVideo.decode(String value) =>
      SavedVideo.fromJson(jsonObject(value));

  Map<String, dynamic> toJson() => {
        'url': url,
        'name': name,
        'imgUrl': imageUrl,
      };

  String encode() => jsonEncode(toJson());

  String get resourceUrl {
    final uri = Uri.parse(url);
    final parameters = Map<String, dynamic>.from(uri.queryParametersAll)
      ..remove('ac')
      ..remove('ids')
      ..remove('wd');
    return uri.replace(queryParameters: parameters).toString();
  }
}
