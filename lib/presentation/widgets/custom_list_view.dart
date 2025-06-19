import 'package:flutter/material.dart';

class CustomListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const CustomListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon,
                size: 80,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              if (emptyTitle != null)
                Text(
                  emptyTitle!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (emptySubtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  emptySubtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (emptyActionLabel != null && onEmptyAction != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onEmptyAction,
                  icon: const Icon(Icons.add),
                  label: Text(emptyActionLabel!),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
