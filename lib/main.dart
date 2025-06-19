import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importa tus vistas y tema

void main() {
  runApp(
    const ProviderScope( // Fundamental para Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viveres Rosita App',
      // theme: ThemeData(...), // Tu tema
      // home: OrdersScreen(), // Tu pantalla inicial
    );
  }
}