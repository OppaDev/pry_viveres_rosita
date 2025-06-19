import 'package:pry_viveres_rosita/domain/entities/order_entity.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(String orderId);
  Future<OrderEntity> createOrder({required int userId, required List<OrderItemEntity> items});
  Future<OrderItemEntity> addOrderItemToOrder({required String orderId, required int productId, required int quantity});
}