import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';
import 'package:pry_viveres_rosita/presentation/providers/order_providers.dart';
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  void _showAddProductDialog(
    BuildContext context,
    WidgetRef ref,
    String currentOrderId,
  ) {
    // Cargar la lista de productos una vez cuando se abre el diálogo
    // Usamos ref.read para no causar reconstrucciones innecesarias del diálogo si la lista cambia mientras está abierto
    final productsAsyncValue = ref.read(productsListProvider);
    final formKey = GlobalKey<FormState>();
    ProductEntity?
    selectedProduct; // Para guardar el producto seleccionado en el Dropdown
    final TextEditingController quantityController = TextEditingController(
      text: '1',
    ); // Cantidad inicial

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return productsAsyncValue.when(
          data: (products) {
            if (products.isEmpty) {
              return AlertDialog(
                title: const Text('Agregar Producto al Pedido'),
                content: const Text(
                  'No hay productos disponibles para agregar.',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cerrar'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              );
            }

            // Usamos StatefulBuilder para que el Dropdown y la validación de cantidad puedan actualizarse
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return AlertDialog(
                  title: const Text('Agregar Producto al Pedido'),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DropdownButtonFormField<ProductEntity>(
                          value: selectedProduct,
                          hint: const Text('Seleccione un producto'),
                          isExpanded: true,
                          items:
                              products.map((ProductEntity product) {
                                return DropdownMenuItem<ProductEntity>(
                                  value: product,
                                  child: Text(
                                    "${product.name} (Stock: ${product.stock})",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                          onChanged: (ProductEntity? newValue) {
                            setDialogState(() {
                              // Actualiza el estado del diálogo
                              selectedProduct = newValue;
                              // Opcional: podrías resetear la cantidad o validarla aquí
                            });
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Seleccione un producto'
                                      : null,
                          decoration: const InputDecoration(
                            labelText: 'Producto',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Ingrese cantidad';
                            final qty = int.tryParse(value);
                            if (qty == null || qty <= 0)
                              return 'Cantidad debe ser mayor a 0';
                            if (selectedProduct != null &&
                                qty > selectedProduct!.stock) {
                              return 'Stock insuficiente (Disp: ${selectedProduct!.stock})';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                    ElevatedButton(
                      child: const Text('Agregar'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (selectedProduct == null)
                            return; // Doble chequeo por si acaso

                          final int productId = selectedProduct!.id;
                          final int quantity = int.parse(
                            quantityController.text,
                          );

                          try {
                            await ref
                                .read(addOrderItemNotifierProvider.notifier)
                                .addOrderItem(
                                  orderId: currentOrderId,
                                  productId: productId,
                                  quantity: quantity,
                                );
                            ref.invalidate(
                              orderDetailProvider(currentOrderId),
                            ); // Recargar detalles
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${selectedProduct!.name} agregado!',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          dialogContext,
                                        ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(
                                      dialogContext,
                                    ).colorScheme.primaryContainer,
                              ),
                            );
                          } catch (e) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: ${e.toString()}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          dialogContext,
                                        ).colorScheme.onErrorContainer,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(
                                      dialogContext,
                                    ).colorScheme.errorContainer,
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
          },
          loading:
              () => const AlertDialog(
                title: Text('Cargando productos...'),
                content: LoadingWidget(
                  showMessage: false,
                ), // Usar tu widget de carga
              ),
          error:
              (err, stack) => AlertDialog(
                title: const Text('Error'),
                content: Text('No se pudieron cargar los productos: $err'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cerrar'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
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
                            ? Colors.green.shade600
                            : (order.state == 'Cancelado'
                                ? Colors.red.shade600
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: EmptyState(
                      // Usando tu widget reutilizable
                      title: 'Sin productos',
                      subtitle: 'Este pedido no tiene productos agregados.',
                      icon: Icons.inventory_2_outlined,
                    ),
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
                const SizedBox(height: 24),
                Center(
                  child: LoadingButton(
                    // Usando tu widget reutilizable
                    text: 'Agregar Producto',
                    icon: Icons.add_shopping_cart,
                    isLoading:
                        ref
                            .watch(addOrderItemNotifierProvider)
                            .isLoading, // Escucha el estado de carga
                    onPressed:
                        (order.state == 'Cancelado' ||
                                order.state == 'Entregado')
                            ? null
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
