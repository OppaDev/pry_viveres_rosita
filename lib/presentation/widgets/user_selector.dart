import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';
import 'package:pry_viveres_rosita/presentation/providers/order_providers.dart';
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';

class UserSelector extends ConsumerWidget {
  final UserEntity? selectedUser;
  final ValueChanged<UserEntity?> onUserSelected;
  final String? label;
  final String? hint;

  const UserSelector({
    super.key,
    this.selectedUser,
    required this.onUserSelected,
    this.label,
    this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
        usersAsyncValue.when(
          data: (users) {
            if (users.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: EmptyState(
                    title: 'No hay usuarios',
                    subtitle: 'No se encontraron usuarios disponibles',
                    icon: Icons.person_outline,
                  ),
                ),
              );
            }

            return DropdownButtonFormField<UserEntity>(
              value: selectedUser,
              hint: Text(hint ?? 'Seleccione un cliente'),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items:
                  users.map((UserEntity user) {
                    return DropdownMenuItem<UserEntity>(
                      value: user,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            user.email,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: onUserSelected,
              validator: (value) {
                if (value == null) {
                  return 'Por favor seleccione un cliente';
                }
                return null;
              },
            );
          },
          loading: () => const LoadingWidget(message: 'Cargando usuarios...'),
          error:
              (err, stack) => CustomErrorWidget(
                message: 'Error al cargar usuarios: $err',
                actionLabel: 'Reintentar',
                onRetry: () {
                  ref.invalidate(usersListProvider);
                },
              ),
        ),
      ],
    );
  }
}
