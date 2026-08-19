
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'package:apprem_v1/Presentation/routers/app_router.dart';

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
   return MaterialApp.router(
      title: 'AppRem Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
        routerConfig: AppRouter.router, //go_router
      );
   
  }
}
