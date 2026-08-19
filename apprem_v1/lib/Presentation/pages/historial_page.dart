
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
  State<HistorialPage> createState()=> _HistorialPageState();
}
class _HistorialPageState extends State<HistorialPage>{

  @override
  void initState(){
    super.initState();
    context.read<HistorialBloc>().add(GetLogHistory());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historal de Remisioines'),
        actions: [
          IconButton(
            onPressed: (){
              context.pushNamed('products');
            }, 
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Productos',
            ),
            IconButton(
              onPressed: (){
                context.pushNamed('clients');
              }, 
              icon: const Icon(Icons.person_2),
              tooltip: 'Clientes',
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Boton para crear nueva remision
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
                 icon: const Icon(Icons.add_circle_outline, size: 24,),
                 label: const Text('Crear nueva Remision', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                 onPressed: ()async {
                  //Apilar
                   await context.push(AppRouter.createRemission);
                  //Al regesar
                     if(context.mounted){
                      context.read<HistorialBloc>().add(GetLogHistory());
                     }
                 },
              ),
            ),
            const SizedBox(height: 16,),
            const Divider(),

            //Lista
            Expanded(
              child: BlocBuilder<HistorialBloc, HistorialState>(
                builder: (context, state){
                  if(state is HistorialLoad){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is HistorialError){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8,),
                          ElevatedButton(
                            onPressed: ()=> context.read<HistorialBloc>().add(GetLogHistory()), 
                            child: const Text('Reintentar')
                            )
                        ],
                      ),
                    );
                  }
                  if(state is HistorialReady){
                    if(state.remission.isEmpty){
                      return const Center(
                        child: Text('No hay remisiones regitradas aun',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                    itemCount: state.remission.length,
                    itemBuilder: (context, index){
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
                          subtitle: Text('Fecha: ${remission.fechaCreacion}'),
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
                              }
                            );
                          },
                        ),
                      );
                    },
                  );
                  }
                  return const SizedBox.shrink();

                }
                ),
            )
            
          ],
        ),
        ),
    );
  }
}