import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/core/config/app_config.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(String orderId);
  Future<OrderEntity> createOrder({
    required int userId,
    required List<Map<String, dynamic>> itemsJson,
  });
  Future<OrderItemEntity> addOrderItemToOrder({
    required String orderId,
    required int productId,
    required int quantity,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});
  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await client.get(Uri.parse(AppConfig.ordersUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => OrderEntity.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final response = await client.get(
      Uri.parse('${AppConfig.ordersUrl}/$orderId'),
    );
    if (response.statusCode == 200) {
      return OrderEntity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load order detail');
    }
  }

  @override
  Future<OrderEntity> createOrder({
    required int userId,
    required List<Map<String, dynamic>> itemsJson,
  }) async {
    final response = await client.post(
      Uri.parse(AppConfig.ordersUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'orderItems': itemsJson}),
    );

    if (response.statusCode == 201) {
      // La API devuelve el objeto 'data' que contiene el pedido creado
      final responseBody = json.decode(response.body);
      return OrderEntity.fromJson(responseBody['data']);
    } else {
      print('Error creating order: ${response.body}');
      throw Exception('Failed to create order. Status: ${response.statusCode}');
    }
  }

  @override
  Future<OrderItemEntity> addOrderItemToOrder({
    required String orderId,
    required int productId,
    required int quantity,
  }) async {
    final response = await client.post(
      Uri.parse('${AppConfig.ordersUrl}/$orderId/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId, 'quantity': quantity}),
    );
    if (response.statusCode == 201) {
      // La API devuelve el objeto 'data' que contiene el item del pedido creado
      final responseBody = json.decode(response.body);
      return OrderItemEntity.fromJson(responseBody['data']);
    } else {
      print('Error adding item: ${response.body}');
      throw Exception(
        'Failed to add item to order. Status: ${response.statusCode}',
      );
    }
  }
}
