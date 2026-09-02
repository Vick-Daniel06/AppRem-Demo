import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Menú Principal',
          style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 columnas
          crossAxisSpacing: 20, // Espacio horizontal entre cuadros
          mainAxisSpacing: 20, // Espacio vertical entre cuadros
          children: [
            // CUADRO 1: Historial de Remisiones
            _buildMenuCard(
              context: context,
              title: 'Historial de\nRemisiones',
              icon: Icons.history,
              onTap: () => context.goNamed('historial'),
            ),

            // CUADRO 2: Crear Clientes
            _buildMenuCard(
              context: context,
              title: 'Crear\nClientes',
              icon: Icons.person_add_alt_1,
              onTap: () => context.goNamed('clients'),
            ),

            // CUADRO 3: Crear Productos
            _buildMenuCard(
               // Placeholder para evitar error de context si es necesario
              context: context,
              title: 'Crear\nProductos',
              icon: Icons.add_shopping_cart,
              onTap: () => context.goNamed('products'),
            ),

            // CUADRO 4: Usuario (Sin funcionalidad por ahora)
            _buildMenuCard(
              context: context,
              title: 'Usuario',
              icon: Icons.person,
              onTap: () {
                debugPrint('Presionaste Usuario - Sin funcionalidad aún');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para los cuadros del menú
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Bordes redondeados suaves para el efecto de click
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue, // Borde azul
            width: 2,           // Grosor del borde
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue, // Icono azul
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue, // Texto azul
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
