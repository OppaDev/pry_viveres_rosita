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
    final productsAsyncValue = ref.read(productsListProvider);

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

            // Variables para manejar el estado dentro del diálogo
            ProductEntity? tempSelectedProduct;
            int quantity = 1;

            return StatefulBuilder(
              // Para manejar el estado de la cantidad internamente
              builder: (stfContext, setDialogState) {
                return AlertDialog(
                  title: const Text('Agregar Producto al Pedido'),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 0,
                  ), // Ajustar padding
                  content: SizedBox(
                    // Darle un tamaño al contenido del diálogo
                    width: double.maxFinite,
                    height:
                        MediaQuery.of(context).size.height *
                        0.5, // ~50% de la altura de pantalla
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              bool isSelected =
                                  tempSelectedProduct?.id == product.id;
                              return ListTile(
                                leading:
                                    product.image.isNotEmpty
                                        ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            product.image,
                                          ),
                                        )
                                        : const CircleAvatar(
                                          child: Icon(Icons.inventory_2),
                                        ),
                                title: Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                  "Stock: ${product.stock} - \$${product.price.toStringAsFixed(2)}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                tileColor:
                                    isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withOpacity(0.3)
                                        : null,
                                onTap: () {
                                  setDialogState(() {
                                    tempSelectedProduct = product;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        if (tempSelectedProduct !=
                            null) // Mostrar campo de cantidad solo si se seleccionó un producto
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              initialValue: quantity.toString(),
                              decoration: InputDecoration(
                                labelText:
                                    'Cantidad para ${tempSelectedProduct!.name}',
                                hintText: 'Max: ${tempSelectedProduct!.stock}',
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                quantity = int.tryParse(val) ?? 1;
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed:
                          tempSelectedProduct == null
                              ? null // Deshabilitar si no hay producto seleccionado
                              : () async {
                                // Validar cantidad antes de agregar
                                final qty = int.tryParse(
                                  quantity.toString(),
                                ); // Re-parsear por si acaso
                                if (qty == null || qty <= 0) {
                                  ScaffoldMessenger.of(
                                    dialogContext,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'La cantidad debe ser mayor a 0.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (tempSelectedProduct != null &&
                                    qty > tempSelectedProduct!.stock) {
                                  ScaffoldMessenger.of(
                                    dialogContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Stock insuficiente. Disponible: ${tempSelectedProduct!.stock}',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final int productId = tempSelectedProduct!.id;
                                final int validQuantity = qty;

                                try {
                                  await ref
                                      .read(
                                        addOrderItemNotifierProvider.notifier,
                                      )
                                      .addOrderItem(
                                        orderId: currentOrderId,
                                        productId: productId,
                                        quantity: validQuantity,
                                      );
                                  ref.invalidate(
                                    orderDetailProvider(currentOrderId),
                                  ); // Recargar detalles
                                  Navigator.of(dialogContext).pop();
                                  ScaffoldMessenger.of(
                                    dialogContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${tempSelectedProduct!.name} agregado!',
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
                                  ScaffoldMessenger.of(
                                    dialogContext,
                                  ).showSnackBar(
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
                              },
                      child: const Text('Agregar'),
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
