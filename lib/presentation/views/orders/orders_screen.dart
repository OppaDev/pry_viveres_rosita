import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/presentation/providers/order_providers.dart';
import 'package:pry_viveres_rosita/presentation/views/orders/order_detail_screen.dart'; // Necesitarás crear esta pantalla
import 'package:pry_viveres_rosita/presentation/views/orders/create_order_screen.dart'; // Necesitarás crear esta pantalla
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsyncValue = ref.watch(ordersListProvider);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mis Pedidos'),
      body: ordersAsyncValue.when(
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              title: 'No hay pedidos aún',
              subtitle: 'Crea tu primer pedido para comenzar',
              icon: Icons.shopping_cart_outlined,
              actionLabel: 'Crear Pedido',
              onActionPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateOrderScreen(),
                  ),
                );
              },
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              OrderDetailScreen(orderId: order.id.toString()),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Cargando pedidos...'),
        error:
            (err, stack) => CustomErrorWidget(
              message: 'Error al cargar los pedidos: $err',
              actionLabel: 'Reintentar',
              onRetry: () {
                // Invalidar el provider para recargar los datos
                ref.invalidate(ordersListProvider);
              },
            ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
          );
        },
        label: 'Nuevo Pedido',
        icon: Icons.add,
      ),
    );
  }
}
