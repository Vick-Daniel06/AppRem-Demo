
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_event.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ClientFormScreen extends StatefulWidget{
  final Client? clientToEdit;
const ClientFormScreen({super.key, this.clientToEdit});
@override
State<ClientFormScreen> createState() => _ClientFormScreenState();
}


class _ClientFormScreenState extends State<ClientFormScreen>{
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ubicacion;

  bool get _isEditing => widget.clientToEdit != null;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(
      text: widget.clientToEdit?.nombre ?? '',
    );
    _ubicacion = TextEditingController(
      text: widget.clientToEdit?.ubicacionCliente ?? '',
    );

  }
  @override
  void dispose(){
    _nameController.dispose();
    _ubicacion.dispose();
    super.dispose();
  }
  void _onSave(BuildContext context){
    if(_formKey.currentState!.validate()){
      final client = Client(
        id: _isEditing ? widget.clientToEdit!.id : const Uuid().v4(), 
        nombre: _nameController.text.trim(), 
        ubicacionCliente: _ubicacion.text.trim(),
        );

        context.read<ClientBloc>().add(
          _isEditing ? UpdateClientEvent(client) : AddClientEvent(client)
        );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cliente': 'Nuevo Cliente'),
      ),
      body: BlocConsumer<ClientBloc, ClientState>
      (
        listener: (context, state){
          if(state is ClientOperationSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          else if(state is ClientError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state){
          final isLoading = state is ClientLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Cliente',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return 'Por favor ingresa el nombre del Cliente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _ubicacion,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Ubicacion',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      validator: (value) {
                        if(value == null || value.trim().isEmpty){
                          return 'Por favor agregar ubicacion';
                        }
                        return null;
                      },
                    ),
                                          const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : () => _onSave(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                      ),
                  ],
                ),
              )
              ),
            );
        }, 
        
      ),
    );
  }
  
}