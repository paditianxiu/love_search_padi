import 'json_value.dart';

class SearchSource {
  final String name;
  final String url;
  final bool openExternally;

  const SearchSource({
    required this.name,
    required this.url,
    this.openExternally = false,
  });

  factory SearchSource.fromJson(Map<String, dynamic> json) => SearchSource(
        name: jsonString(json['name']),
        url: jsonString(json['url']),
        openExternally: json['push'] == true || json['push'] == 'true',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'push': openExternally,
      };
}
