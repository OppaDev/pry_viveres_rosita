import 'package:pry_viveres_rosita/data/datasources/remote/order_remote_data_source.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderEntity>> getOrders() async {
    return await remoteDataSource.getOrders();
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    return await remoteDataSource.getOrderById(orderId);
  }

  @override
  Future<OrderEntity> createOrder({required int userId, required List<OrderItemEntity> items}) async {
    // Convert OrderItemEntity list to List<Map<String, dynamic>> for the request
    final itemsJson = items.map((item) => item.toJsonForRequest()).toList();
    return await remoteDataSource.createOrder(userId: userId, itemsJson: itemsJson);
  }

  @override
  Future<OrderItemEntity> addOrderItemToOrder({required String orderId, required int productId, required int quantity}) async {
    return await remoteDataSource.addOrderItemToOrder(orderId: orderId, productId: productId, quantity: quantity);
  }
}