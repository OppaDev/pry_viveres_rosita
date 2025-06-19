import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderEntity> call({required int userId, required List<OrderItemEntity> items}) async {
    // Aquí podrías agregar lógica de negocio si fuera necesario antes de llamar al repositorio
    return await repository.createOrder(userId: userId, items: items);
  }
}