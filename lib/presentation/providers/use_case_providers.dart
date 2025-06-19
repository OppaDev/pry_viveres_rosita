import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/application/usecases/get_orders_usecase.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/application/usecases/get_order_by_id_usecase.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/application/usecases/create_order_usecase.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/application/usecases/add_order_item_usecase.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/application/usecases/get_products_usecase.dart'; // Ajusta la ruta
import 'repository_providers.dart'; // Ajusta la ruta

final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrdersUseCase(repository);
});

final getOrderByIdUseCaseProvider = Provider<GetOrderByIdUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrderByIdUseCase(repository);
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderUseCase(repository);
});

final addOrderItemUseCaseProvider = Provider<AddOrderItemUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return AddOrderItemUseCase(repository);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository);
});