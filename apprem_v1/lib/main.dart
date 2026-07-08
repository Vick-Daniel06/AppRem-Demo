import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  // Asegura que los bindings nativos de Flutter estén listos antes de inicializar dependencias
  WidgetsFlutterBinding.ensureInitialized();
  // inicia el contenedor de dependencias
  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      title: 'AppRem Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('¡Motor de dependencias e infraestructura LISTO!')),
      ),
    );
  }
}
