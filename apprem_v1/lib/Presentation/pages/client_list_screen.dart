
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_event.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen>{

  @override
  void initState() {
    super.initState();
    context.read<ClientBloc>().add(LoadClientEvent());
  }

  Future<void> _navigateToForm (BuildContext context , {Client? client}) async{
    final result = await context.pushNamed<bool>('client/form', extra: client);

    if(result == true && context.mounted){
      context.read<ClientBloc>().add(LoadClientEvent());
    }
  }

  void _confirmDelete (BuildContext context, String id){
    showDialog(
      context: context, 
      builder:  (dialogContextx) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: const Text('Estas seguro de eliminar este Cliente?'),
        actions: [
          TextButton(
            onPressed: ()=> Navigator.pop(dialogContextx), 
            child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: (){
                context.read<ClientBloc>().add(DeleteClientEvent(id));
                Navigator.pop(dialogContextx);
              }, 
              child: const Text('Eliminar', style: TextStyle(color: Colors.red),)
              )
        ],
       )
      );
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuevo Cliente',
            onPressed: () => _navigateToForm(context),
          ),
        ],
      ),
      body: BlocConsumer<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ClientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ClientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClientLoaded) {
            if (state.clients.isEmpty) {
              return const Center(
                child: Text('No hay clientes registrados aún.'),
              );
            }

            return ListView.separated(
              itemCount: state.clients.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(
                    client.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    client.ubicacionCliente ?? 'No se registro ubicacion',
                    maxLines: 1,

                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(context, client.id),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToForm(context, client: client),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  
  }
}