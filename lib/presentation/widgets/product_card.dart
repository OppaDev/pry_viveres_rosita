import 'package:flutter/material.dart';
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showStock;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.trailing,
    this.showStock = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.image),
          onBackgroundImageError: (exception, stackTrace) {},
          child: product.image.isEmpty ? const Icon(Icons.inventory_2) : null,
        ),
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showStock) ...[
              const SizedBox(height: 2),
              Text(
                'Stock: ${product.stock}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: product.stock > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
        trailing: trailing,
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }
}
