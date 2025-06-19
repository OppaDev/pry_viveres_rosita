import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart';
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart';
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
  // En una app real, el userId vendría del usuario logueado
  final int _userId = 3; // Ejemplo: ID de usuario fijo

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
    final productsAsyncValue = ref.read(
      productsListProvider,
    ); // Leer una vez para el dialogo

    productsAsyncValue.when(
      data: (products) {
        ProductEntity? selectedProduct =
            products.isNotEmpty ? products.first : null;
        int quantity = 1;

        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
              // Para actualizar el Dropdown dentro del dialogo
              builder: (context, setDialogState) {
                return AlertDialog(
                  title: const Text('Seleccionar Producto'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (products.isEmpty)
                        const Text('No hay productos disponibles.')
                      else
                        DropdownButtonFormField<ProductEntity>(
                          value: selectedProduct,
                          hint: const Text('Seleccione un producto'),
                          items:
                              products.map((ProductEntity product) {
                                return DropdownMenuItem<ProductEntity>(
                                  value: product,
                                  child: Text(
                                    "${product.name} - \$${product.price.toStringAsFixed(2)} (Stock: ${product.stock})",
                                  ),
                                );
                              }).toList(),
                          onChanged: (ProductEntity? newValue) {
                            setDialogState(() {
                              selectedProduct = newValue;
                            });
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Seleccione un producto'
                                      : null,
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: quantity.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          quantity = int.tryParse(val) ?? 1;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Ingrese cantidad';
                          final qty = int.tryParse(value);
                          if (qty == null || qty <= 0)
                            return 'Cantidad debe ser > 0';
                          if (selectedProduct != null &&
                              qty > selectedProduct!.stock)
                            return 'Stock insuficiente (${selectedProduct!.stock})';
                          return null;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed:
                          products.isEmpty || selectedProduct == null
                              ? null
                              : () {
                                if (quantity > 0 &&
                                    selectedProduct!.stock >= quantity) {
                                  _addProductToOrder(
                                    selectedProduct!,
                                    quantity,
                                  );
                                  Navigator.of(dialogContext).pop();
                                } else {
                                  // Mostrar error de stock si no se validó antes
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Cantidad inválida o stock insuficiente.',
                                      ),
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
        );
      },
      loading:
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cargando productos...')),
          ),
      error:
          (err, stack) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error productos: $err'))),
    );
  }

  Future<void> _submitOrder() async {
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
          .createOrder(userId: _userId, items: _currentOrderItems);
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
              Text(
                'Cliente ID: $_userId (Ejemplo)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Añadir Producto al Pedido'),
                onPressed: _showSelectProductDialog,
              ),
              const SizedBox(height: 20),
              Text(
                'Productos en el pedido:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Expanded(
                child:
                    _currentOrderItems.isEmpty
                        ? EmptyState(
                          title: 'Carrito vacío',
                          subtitle: 'Añade productos para crear tu pedido',
                          icon: Icons.shopping_cart_outlined,
                          actionLabel: 'Añadir Producto',
                          onActionPressed: _showSelectProductDialog,
                        )
                        : ListView.builder(
                          itemCount: _currentOrderItems.length,
                          itemBuilder: (context, index) {
                            final item = _currentOrderItems[index];
                            return OrderItemTile(
                              orderItem: item,
                              showTotal: true,
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
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
              const SizedBox(height: 20),
              LoadingButton(
                text: 'Confirmar Pedido',
                isLoading: createOrderState.isLoading,
                onPressed: _submitOrder,
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
