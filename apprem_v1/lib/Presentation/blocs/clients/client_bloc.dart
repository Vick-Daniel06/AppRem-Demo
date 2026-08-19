


import 'package:apprem_v1/Domain/usecases/client/delete_client_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/get_clients_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/save_client_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/update_client_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_event.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
final DeleteClientUseCase _deleteClientUseCase;
final GetClientsUseCase _getClientsUseCase;
final SaveClientUseCase _saveClientUseCase;
final UpdateClientUseCase _updateClientUseCase;

ClientBloc({
  required DeleteClientUseCase deleteClientUseCase,
  required GetClientsUseCase getClientsUseCase,
  required SaveClientUseCase saveClientUseCase,
  required UpdateClientUseCase updateClientUseCase,
}) : 
_deleteClientUseCase = deleteClientUseCase,
_getClientsUseCase = getClientsUseCase,
_saveClientUseCase = saveClientUseCase,
_updateClientUseCase = updateClientUseCase,
super(ClientInitial()){
  on<LoadClientEvent>(_onloadClient);
  on<AddClientEvent>(_onAddClient);
  on<UpdateClientEvent>(_onUpdateClient);
  on<DeleteClientEvent>(_onDeleteClient);
}

Future<void> _onloadClient (LoadClientEvent event, Emitter<ClientState> emit) async
{
  emit(ClientLoading());
  try{
    final client = await _getClientsUseCase();
    emit(ClientLoaded(client));
  }catch(e){
    emit(ClientError('Error al cargar clientes : ${e.toString()}'));
  }
}
Future<void> _onAddClient (AddClientEvent event, Emitter<ClientState> emit) async{
  emit(ClientLoading());

  try{
    await _saveClientUseCase(event.client);
    emit(const ClientOperationSuccess('Cliente guardado con exito'));
    add(LoadClientEvent());

  } catch(e){
    emit(ClientError('Error al querer guardar cliente ${e.toString()}'));
  }
}

Future<void> _onUpdateClient(UpdateClientEvent event, Emitter<ClientState> emit) async{
  emit(ClientLoading());
  try{
    await _updateClientUseCase(event.client);
    emit(const ClientOperationSuccess('Cliente actualizado'));
    add(LoadClientEvent());
  }catch(e){
    emit(ClientError('Error al actualizar cliente${e.toString()}'));
  }
}
Future<void> _onDeleteClient (DeleteClientEvent event, Emitter<ClientState> emit) async{
  emit(ClientLoading());
  try{
    await _deleteClientUseCase(event.id);
    emit(ClientOperationSuccess('Cliente eliminado correctamente'));
    add(LoadClientEvent());
  }catch(e){
    emit(ClientError('Error al eliminar cliente ${e.toString()}'));
  }
}


}