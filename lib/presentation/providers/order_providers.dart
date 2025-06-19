import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/user_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/application/usecases/create_order_usecase.dart'; // Import del use case
import 'package:pry_viveres_rosita/application/usecases/add_order_item_usecase.dart'; // Import del use case
import 'use_case_providers.dart'; // Ajusta la ruta

// Provider para obtener la lista de todos los pedidos
final ordersListProvider = FutureProvider<List<OrderEntity>>((ref) async {
  final getOrdersUseCase = ref.watch(getOrdersUseCaseProvider);
  return getOrdersUseCase.call();
});

// Provider para obtener el detalle de un pedido específico
// Usamos .family para pasar el orderId como parámetro
final orderDetailProvider = FutureProvider.family<OrderEntity, String>((
  ref,
  orderId,
) async {
  final getOrderByIdUseCase = ref.watch(getOrderByIdUseCaseProvider);
  return getOrderByIdUseCase.call(orderId);
});

// Provider para obtener la lista de productos
final productsListProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final getProductsUseCase = ref.watch(getProductsUseCaseProvider);
  return getProductsUseCase.call();
});

// Provider para obtener la lista de usuarios/clientes
final usersListProvider = FutureProvider<List<UserEntity>>((ref) async {
  final getUsersUseCase = ref.watch(getUsersUseCaseProvider);
  return getUsersUseCase.call();
});

// Para operaciones de escritura (crear, agregar), usarías StateNotifierProvider
// o llamarías directamente al use case y manejarías el estado con setState o
// un FutureBuilder/Consumer que reaccione al resultado.

// Ejemplo de un Notifier para crear un pedido:
class CreateOrderNotifier extends StateNotifier<AsyncValue<OrderEntity?>> {
  final CreateOrderUseCase _createOrderUseCase;

  CreateOrderNotifier(this._createOrderUseCase)
    : super(const AsyncValue.data(null));

  Future<void> createOrder({
    required int userId,
    required List<OrderItemEntity> items,
  }) async {
    state = const AsyncValue.loading();
    try {
      final newOrder = await _createOrderUseCase.call(
        userId: userId,
        items: items,
      );
      state = AsyncValue.data(newOrder);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final createOrderNotifierProvider =
    StateNotifierProvider<CreateOrderNotifier, AsyncValue<OrderEntity?>>((ref) {
      final useCase = ref.watch(createOrderUseCaseProvider);
      return CreateOrderNotifier(useCase);
    });

// Ejemplo de un Notifier para agregar un item a un pedido:
class AddOrderItemNotifier extends StateNotifier<AsyncValue<OrderItemEntity?>> {
  final AddOrderItemUseCase _addOrderItemUseCase;

  AddOrderItemNotifier(this._addOrderItemUseCase)
    : super(const AsyncValue.data(null));

  Future<void> addOrderItem({
    required String orderId,
    required int productId,
    required int quantity,
  }) async {
    state = const AsyncValue.loading();
    try {
      final newItem = await _addOrderItemUseCase.call(
        orderId: orderId,
        productId: productId,
        quantity: quantity,
      );
      state = AsyncValue.data(newItem);
      // Aquí podrías querer invalidar el provider de detalle del pedido para que se refresque
      // ref.invalidate(orderDetailProvider(orderId));
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final addOrderItemNotifierProvider = StateNotifierProvider<
  AddOrderItemNotifier,
  AsyncValue<OrderItemEntity?>
>((ref) {
  final useCase = ref.watch(addOrderItemUseCaseProvider);
  // Podrías pasar el ref al notifier si necesitas invalidar otros providers desde dentro
  return AddOrderItemNotifier(useCase);
});
