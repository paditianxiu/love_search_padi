import 'dart:convert';

Object? decodeJson(Object? value) =>
    value is String ? jsonDecode(value) : value;

Map<String, dynamic> jsonObject(Object? value) {
  final decoded = decodeJson(value);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('接口数据应为 JSON 对象');
  }
  return decoded;
}

List<Map<String, dynamic>> jsonObjects(Object? value) {
  final decoded = decodeJson(value);
  if (decoded is! List) {
    throw const FormatException('接口数据应为 JSON 数组');
  }
  return decoded.map(jsonObject).toList();
}

String jsonString(Object? value) => value?.toString() ?? '';
