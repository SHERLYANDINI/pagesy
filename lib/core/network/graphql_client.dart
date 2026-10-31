import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

// Class kustom untuk memperpanjang durasi timeout HTTP client GraphQL menjadi 30 detik
class TimeoutHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final Duration timeout;

  TimeoutHttpClient(this.timeout);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request).timeout(timeout);
  }
}

final graphQLClientProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  // Gunakan TimeoutHttpClient dengan durasi 30 detik agar pencarian pertama yang memanggil API eksternal aman dari timeout
  final HttpLink httpLink = HttpLink(
    'http://127.0.0.1:8000/pagesy', // Sesuaikan jika menggunakan Android Emulator (10.0.2.2)
    httpClient: TimeoutHttpClient(const Duration(seconds: 30)),
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  return client;
});
