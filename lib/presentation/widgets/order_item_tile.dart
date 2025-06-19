import 'package:flutter/material.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItemEntity orderItem;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showTotal;

  const OrderItemTile({
    super.key,
    required this.orderItem,
    this.onTap,
    this.trailing,
    this.showTotal = true,
  });

  @override
  Widget build(BuildContext context) {
    final product = orderItem.product;
    final total = orderItem.quantity * orderItem.unitPrice;

    return ListTile(
      leading:
          product?.image != null && product!.image.isNotEmpty
              ? CircleAvatar(
                backgroundImage: NetworkImage(product.image),
                onBackgroundImageError: (exception, stackTrace) {},
              )
              : const CircleAvatar(child: Icon(Icons.inventory_2)),
      title: Text(
        product?.name ?? 'Producto #${orderItem.productId}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cantidad: ${orderItem.quantity}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Precio unitario: \$${orderItem.unitPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (showTotal)
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      trailing: trailing,
      onTap: onTap,
      isThreeLine: showTotal,
    );
  }
}
