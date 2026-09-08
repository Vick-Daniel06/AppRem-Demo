
import 'package:apprem_v1/Presentation/blocs/historial/historial_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_event.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_state.dart';
import 'package:apprem_v1/Presentation/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    
    // Carga inicial al abrir la pantalla
    context.read<HistorialBloc>().add(GetHistoryInitial());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Detecta cuando el usuario está cerca del final para pedir la siguiente página
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<HistorialBloc>().add(GetNextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Remisiones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón para crear nueva remisión
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text(
                  'Crear nueva Remision',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await context.push(AppRouter.createRemission);
                  if (context.mounted) {
                    // Recargamos desde la página 1 al volver de crear
                    context.read<HistorialBloc>().add(GetHistoryInitial());
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Lista Paginada
            Expanded(
              child: BlocBuilder<HistorialBloc, HistorialState>(
                builder: (context, state) {
                  // Carga inicial cuando la lista está vacía
                  if (state.isLoading && state.remission.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Mensaje de Error
                  if (state.error != null && state.remission.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => context
                                .read<HistorialBloc>()
                                .add(GetHistoryInitial()),
                            child: const Text('Reintentar'),
                          )
                        ],
                      ),
                    );
                  }

                  // Lista Vacía
                  if (state.remission.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay remisiones registradas aún',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  // Lista con Datos (Paginación activa)
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax
                        ? state.remission.length
                        : state.remission.length + 1, // +1 para el spinner de pie de página
                    itemBuilder: (context, index) {
                      // Spinner de carga al final de la lista al hacer scroll
                      if (index >= state.remission.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final remission = state.remission[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              '#${remission.folio}',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            remission.nombreCliente,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Fecha: ${remission.fechaCreacion.toString().split(' ')[0]}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${remission.montoTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.green,
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                            ],
                          ),
                          onTap: () {
                            context.pushNamed(
                              'pdfPreview',
                              pathParameters: {
                                'id': remission.id,
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}