# Widgets Reutilizables

Esta carpeta contiene widgets reutilizables para evitar la duplicación de código en toda la aplicación de Viveres Rosita.

## Widgets Disponibles

### 1. OrderCard (`order_card.dart`)
Widget para mostrar información de pedidos en formato de tarjeta.

**Características:**
- Muestra información básica del pedido (ID, cliente, estado, fecha)
- Soporte para callbacks de tap personalizado
- Trailing widget personalizable
- Formato de fecha automático

**Uso:**
```dart
OrderCard(
  order: orderEntity,
  onTap: () => Navigator.push(...),
)
```

### 2. ProductCard (`product_card.dart`)
Widget para mostrar productos en listas o grids.

**Características:**
- Imagen del producto con fallback
- Información completa del producto
- Indicador de stock con colores
- Precio formateado
- Trailing widget personalizable

**Uso:**
```dart
ProductCard(
  product: productEntity,
  showStock: true,
  onTap: () => selectProduct(product),
)
```

### 3. OrderItemTile (`order_item_tile.dart`)
Widget para mostrar items individuales dentro de un pedido.

**Características:**
- Imagen del producto
- Cantidad y precios
- Cálculo automático del total
- Opción de mostrar/ocultar total

**Uso:**
```dart
OrderItemTile(
  orderItem: orderItemEntity,
  showTotal: true,
  onTap: () => editItem(orderItem),
)
```

### 4. EmptyState (`empty_state.dart`)
Widget para mostrar estados vacíos consistentes.

**Características:**
- Icono personalizable
- Título y subtítulo
- Botón de acción opcional
- Diseño centrado y responsive

**Uso:**
```dart
EmptyState(
  title: 'No hay pedidos',
  subtitle: 'Crea tu primer pedido',
  icon: Icons.shopping_cart_outlined,
  actionLabel: 'Crear Pedido',
  onActionPressed: () => createOrder(),
)
```

### 5. LoadingWidget (`loading_widget.dart`)
Widget para mostrar indicadores de carga consistentes.

**Características:**
- Indicador de progreso circular
- Mensaje opcional
- Diseño centrado

**Uso:**
```dart
LoadingWidget(message: 'Cargando pedidos...')
```

### 6. CustomErrorWidget (`error_widget.dart`)
Widget para mostrar errores de manera consistente.

**Características:**
- Icono de error
- Mensaje personalizable
- Botón de reintento opcional
- Diseño centrado

**Uso:**
```dart
CustomErrorWidget(
  message: 'Error al cargar datos',
  actionLabel: 'Reintentar',
  onRetry: () => reload(),
)
```

### 7. ThemeToggleButton (`theme_toggle_button.dart`)
Botón para alternar entre tema claro y oscuro.

**Características:**
- Icono dinámico según el tema actual
- Tooltip descriptivo
- Integración con Riverpod

**Uso:**
```dart
const ThemeToggleButton()
```

### 8. CustomAppBar (`custom_app_bar.dart`)
AppBar reutilizable con funcionalidades comunes.

**Características:**
- Botón de tema integrado opcional
- Actions personalizables
- Leading personalizable
- Implementa PreferredSizeWidget

**Uso:**
```dart
CustomAppBar(
  title: 'Mi Pantalla',
  showThemeToggle: true,
  actions: [IconButton(...)],
)
```

### 9. CustomFloatingActionButton (`custom_floating_action_button.dart`)
FloatingActionButton reutilizable con opciones.

**Características:**
- Modo extendido o normal
- Icono y etiqueta personalizables
- Tooltip automático

**Uso:**
```dart
CustomFloatingActionButton(
  onPressed: () => createNew(),
  label: 'Nuevo',
  icon: Icons.add,
  extended: true,
)
```

### 10. CustomListView (`custom_list_view.dart`)
ListView genérico con estado vacío integrado.

**Características:**
- Genérico para cualquier tipo de dato
- Estado vacío automático
- Padding y configuración personalizable
- ItemBuilder flexible

**Uso:**
```dart
CustomListView<ProductEntity>(
  items: products,
  itemBuilder: (context, product, index) => ProductCard(product: product),
  emptyTitle: 'No hay productos',
  emptyActionLabel: 'Agregar Producto',
  onEmptyAction: () => addProduct(),
)
```

### 11. LoadingButton (`loading_button.dart`)
Botones con estados de carga integrados.

**Características:**
- ElevatedButton con indicador de carga
- IconButton con indicador de carga
- Deshabilitación automática durante carga
- Icono y texto personalizables

**Uso:**
```dart
LoadingButton(
  text: 'Confirmar',
  isLoading: isProcessing,
  onPressed: () => processAction(),
  icon: Icons.check,
)

LoadingIconButton(
  icon: Icons.refresh,
  isLoading: isRefreshing,
  onPressed: () => refresh(),
  tooltip: 'Actualizar',
)
```

### 12. UserSelector (`user_selector.dart`)
Widget para selección dinámica de usuarios/clientes.

**Características:**
- Dropdown con lista de usuarios desde la API
- Estados de carga, error y vacío integrados
- Validación automática de selección
- Muestra nombre y email del usuario
- Manejo de errores con opción de reintento

**Uso:**
```dart
UserSelector(
  label: 'Seleccionar Cliente',
  selectedUser: selectedUser,
  onUserSelected: (user) => setState(() => selectedUser = user),
  hint: 'Seleccione el cliente para este pedido',
)
```

## Archivo de Barril (`widgets.dart`)

Todos los widgets están exportados a través del archivo `widgets.dart` para facilitar las importaciones:

```dart
import 'package:pry_viveres_rosita/presentation/widgets/widgets.dart';
```

## Beneficios

1. **Consistencia**: Todos los widgets siguen los mismos patrones de diseño
2. **Reutilización**: Evita duplicación de código
3. **Mantenimiento**: Cambios centralizados
4. **Temas**: Todos los widgets respetan el tema de la aplicación
5. **Accesibilidad**: Tooltips y etiquetas descriptivas
6. **Flexibilidad**: Opciones de personalización sin perder consistencia

## Convenciones

- Todos los widgets son `StatelessWidget` cuando es posible
- Uso de `ConsumerWidget` solo cuando necesitan acceso a Riverpod
- Propiedades opcionales con valores por defecto sensatos
- Documentación inline para parámetros complejos
- Nombres descriptivos y claros
