import 'package:flutter/material.dart';
import 'package:pry_viveres_rosita/domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final Widget? trailing;

  const OrderCard({super.key, required this.order, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          'Pedido #${order.id} - Cliente: ${order.user?.name ?? 'Desconocido'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Estado: ${order.state}\nFecha: ${_formatDate(order.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return date.toLocal().toString().substring(0, 16);
  }
}
