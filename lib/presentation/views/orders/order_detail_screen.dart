import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';
import 'package:pry_viveres_rosita/presentation/providers/order_providers.dart';
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';
// Importar pantalla de selección de productos si es necesario para agregar items
// import 'package:pry_viveres_rosita/presentation/views/products/select_product_screen.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  void _showAddProductDialog(
    BuildContext context,
    WidgetRef ref,
    String currentOrderId,
  ) {
    final TextEditingController productIdController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Idealmente, aquí tendrías un selector de productos en lugar de pedir el ID
    // Pero para un ejemplo rápido:
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Agregar Producto al Pedido'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: productIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID del Producto',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingrese ID de producto';
                    if (int.tryParse(value) == null)
                      return 'ID debe ser numérico';
                    return null;
                  },
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingrese cantidad';
                    final qty = int.tryParse(value);
                    if (qty == null || qty <= 0)
                      return 'Cantidad debe ser mayor a 0';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Agregar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final productId = int.parse(productIdController.text);
                  final quantity = int.parse(quantityController.text);

                  try {
                    // Usar el notifier para agregar el item
                    await ref
                        .read(addOrderItemNotifierProvider.notifier)
                        .addOrderItem(
                          orderId: currentOrderId,
                          productId: productId,
                          quantity: quantity,
                        );
                    // Invalidar para recargar los detalles del pedido
                    ref.invalidate(orderDetailProvider(currentOrderId));
                    Navigator.of(dialogContext).pop(); // Cierra el dialogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Producto agregado correctamente!',
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                    );
                  } catch (e) {
                    Navigator.of(dialogContext).pop(); // Cierra el dialogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al agregar: ${e.toString()}',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailAsyncValue = ref.watch(orderDetailProvider(orderId));

    // Escuchar cambios en el notifier de agregar item para mostrar mensajes o recargar
    ref.listen<AsyncValue<OrderItemEntity?>>(addOrderItemNotifierProvider, (
      _,
      state,
    ) {
      state.whenOrNull(
        data: (item) {
          if (item != null) {
            // Ya invalidamos y mostramos SnackBar en el dialogo
          }
        },
        error: (error, stackTrace) {
          // Ya se maneja en el dialogo
        },
      );
    });
    return Scaffold(
      appBar: CustomAppBar(title: 'Detalle Pedido #$orderId'),
      body: orderDetailAsyncValue.when(
        data: (order) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cliente: ${order.user?.name ?? 'N/A'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${order.user?.email ?? 'N/A'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Estado: ${order.state}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        order.state == 'Entregado'
                            ? Colors.green
                            : (order.state == 'Cancelado'
                                ? Colors.red
                                : Theme.of(context).colorScheme.secondary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${order.createdAt.toLocal().toString().substring(0, 16)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Productos:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (order.orderItems.isEmpty)
                  const EmptyState(
                    title: 'Sin productos',
                    subtitle: 'Este pedido no tiene productos agregados',
                    icon: Icons.inventory_outlined,
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = order.orderItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: OrderItemTile(orderItem: item, showTotal: true),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Agregar Producto'),
                    onPressed:
                        (order.state == 'Cancelado' ||
                                order.state == 'Entregado')
                            ? null // Deshabilitar si el pedido está cancelado o entregado
                            : () =>
                                _showAddProductDialog(context, ref, orderId),
                  ),
                ),
              ],
            ),
          );
        },
        loading:
            () =>
                const LoadingWidget(message: 'Cargando detalle del pedido...'),
        error:
            (err, stack) => CustomErrorWidget(
              message: 'Error al cargar detalle: $err',
              actionLabel: 'Reintentar',
              onRetry: () {
                // Invalidar el provider para recargar los datos
                ref.invalidate(orderDetailProvider(orderId));
              },
            ),
      ),
    );
  }
}
