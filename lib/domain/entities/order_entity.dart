import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/user_entity.dart'; // Ajusta la ruta

class OrderEntity {
  final int id;
  final int userId;
  final String state;
  final DateTime createdAt;
  final List<OrderItemEntity> orderItems;
  final UserEntity? user; // El cliente asociado
  // final CarrierEntity? carrier; // Opcional, si necesitas mostrarlo

  OrderEntity({
    required this.id,
    required this.userId,
    required this.state,
    required this.createdAt,
    required this.orderItems,
    this.user,
    // this.carrier,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['orderItems'] as List? ?? [];
    List<OrderItemEntity> itemList =
        itemsFromJson.map((i) => OrderItemEntity.fromJson(i)).toList();

    return OrderEntity(
      id: json['id'],
      userId: json['user_id'] ?? json['userId'],
      state: json['state'],
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt']),
      orderItems: itemList,
      user: json['user'] != null ? UserEntity.fromJson(json['user']) : null,
      // carrier: json['carrier'] != null ? CarrierEntity.fromJson(json['carrier']) : null,
    );
  }
}