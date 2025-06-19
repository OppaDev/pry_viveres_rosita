import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart';
import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';
import 'package:pry_viveres_rosita/presentation/providers/order_providers.dart';
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<OrderItemEntity> _currentOrderItems = [];

  // Usuario seleccionado dinámicamente
  UserEntity? _selectedUser;

  void _addProductToOrder(ProductEntity product, int quantity) {
    if (quantity <= 0) return;

    setState(() {
      // Verificar si el producto ya está en la lista para actualizar cantidad
      // o agregarlo. Por simplicidad, aquí solo agregamos.
      _currentOrderItems.add(
        OrderItemEntity(
          productId: product.id,
          quantity: quantity,
          unitPrice: product.price, // El backend lo validará de todas formas
          product: product,
        ),
      );
    });
  }

  void _showSelectProductDialog() {
    final productsAsyncValue = ref.read(productsListProvider);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return productsAsyncValue.when(
          data: (products) {
            if (products.isEmpty) {
              return AlertDialog(
                title: const Text('Seleccionar Producto'),
                content: const Text('No hay productos disponibles.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cerrar'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              );
            }

            // Usaremos un StatefulWidget simple dentro del diálogo para manejar la cantidad
            ProductEntity? tempSelectedProduct;
            int quantity = 1;

            return StatefulBuilder(
              // Para manejar el estado de la cantidad internamente
              builder: (stfContext, setDialogState) {
                return AlertDialog(
                  title: const Text('Seleccionar Producto'),
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
                                // Usando tu ProductCard simplificado o un ListTile customizado
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
                              : () {
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
                                _addProductToOrder(
                                  tempSelectedProduct!,
                                  quantity,
                                );
                                Navigator.of(dialogContext).pop();
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
                content: LoadingWidget(showMessage: false),
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

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione un cliente.')),
      );
      return;
    }

    if (_currentOrderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agregue al menos un producto al pedido.'),
        ),
      );
      return;
    }

    try {
      await ref
          .read(createOrderNotifierProvider.notifier)
          .createOrder(userId: _selectedUser!.id, items: _currentOrderItems);
      // Escuchar el resultado en el listener de abajo
    } catch (e) {
      // El notifier ya maneja el estado de error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar el estado del notifier para la creación del pedido
    ref.listen<AsyncValue<dynamic>>(createOrderNotifierProvider, (_, state) {
      state.whenOrNull(
        data: (order) {
          if (order != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pedido creado exitosamente!')),
            );
            ref.invalidate(
              ordersListProvider,
            ); // Para refrescar la lista de pedidos
            Navigator.of(context).pop(); // Volver a la pantalla anterior
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear el pedido: ${error.toString()}'),
            ),
          );
        },
        loading: () {
          // Puedes mostrar un loader global si lo deseas
        },
      );
    });

    final createOrderState = ref.watch(createOrderNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Crear Nuevo Pedido'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserSelector(
                label: 'Cliente:', // Etiqueta más corta
                selectedUser: _selectedUser,
                onUserSelected: (user) {
                  setState(() {
                    _selectedUser = user;
                  });
                },
                hint: 'Seleccione un cliente', // Hint más corto
              ),
              const SizedBox(height: 16), // Ajustar espaciado
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add_shopping_cart_outlined,
                ), // Icono más adecuado
                label: const Text('Añadir Producto al Pedido'),
                onPressed: _showSelectProductDialog,
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(vertical: 12) // Ajustar padding si es necesario
                ),
              ),
              const SizedBox(height: 16), // Ajustar espaciado
              Text(
                'Productos en el pedido:',
                style:
                    Theme.of(context)
                        .textTheme
                        .titleLarge, // Estilo más prominente para el título de la sección
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    _currentOrderItems.isEmpty
                        ? EmptyState(
                          // Tu widget EmptyState
                          title: 'Carrito vacío',
                          subtitle:
                              'Añade productos para crear tu pedido.', // Ya no necesita el botón aquí
                          icon:
                              Icons
                                  .production_quantity_limits_rounded, // Icono alternativo
                        )
                        : ListView.builder(
                          itemCount: _currentOrderItems.length,
                          itemBuilder: (context, index) {
                            final item = _currentOrderItems[index];
                            // Usando tu OrderItemTile
                            return OrderItemTile(
                              orderItem: item,
                              showTotal: true, // Mostrar subtotal por ítem
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _currentOrderItems.removeAt(index);
                                  });
                                },
                                tooltip: 'Eliminar producto',
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 16), // Ajustar espaciado
              LoadingButton(
                // Tu widget LoadingButton
                text: 'Confirmar Pedido',
                isLoading: createOrderState.isLoading,
                onPressed: _submitOrder,
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
