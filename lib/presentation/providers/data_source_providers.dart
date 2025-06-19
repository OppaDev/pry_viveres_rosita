import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pry_viveres_rosita/data/datasources/remote/order_remote_data_source.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/data/datasources/remote/product_remote_data_source.dart'; // Ajusta la ruta

// Provider for HttpClient
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Provider for OrderRemoteDataSource
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return OrderRemoteDataSourceImpl(client: client);
});

// Provider for ProductRemoteDataSource
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return ProductRemoteDataSourceImpl(client: client);
});