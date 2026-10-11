import 'dart:typed_data';

import 'package:dio/dio.dart';

class StubHttpAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) respond;
  final List<RequestOptions> requests = [];

  StubHttpAdapter(this.respond);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}
