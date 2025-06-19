import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/data/repositories/order_repository_impl.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/data/repositories/product_repository_impl.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/data/repositories/user_repository_impl.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/product_repository.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/user_repository.dart'; // Ajusta la ruta
import 'data_source_providers.dart'; // Ajusta la ruta

// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remoteDataSource = ref.watch(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provider for ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});
