// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_viveres_rosita/presentation/views/orders/orders_screen.dart'; // Asegúrate que esta pantalla exista
import 'package:pry_viveres_rosita/theme/app_themes.dart';

// Provider para el ThemeNotifier
final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(ThemeMode.system); // O ThemeMode.light / ThemeMode.dark por defecto
});

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget { // Cambia a ConsumerWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Agrega WidgetRef
    final themeMode = ref.watch(themeNotifierProvider).value; // Escucha el modo del tema

    return MaterialApp(
      title: 'Viveres Rosita App',
      theme: AppThemes.lightTheme, // Tu tema claro
      darkTheme: AppThemes.darkTheme, // Tu tema oscuro
      themeMode: themeMode, // Controlado por el notifier
      debugShowCheckedModeBanner: false,
      home: const OrdersScreen(), // Define esta pantalla como tu pantalla inicial
    );
  }
}