


import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';
import 'package:apprem_v1/Domain/usecases/client/save_client_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_event.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
final ClientRepository _clientRepository;
final SaveClientUseCase _saveClientUseCase;

ClientBloc({
  required ClientRepository clientReposritory,
  required SaveClientUseCase saveClientUseCase,

}) : 
_clientRepository = clientReposritory,
_saveClientUseCase = saveClientUseCase,
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
    final client = await _clientRepository.obtenerClientes();
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
    await _clientRepository.actualizarCliente(event.client);
    emit(const ClientOperationSuccess('Cliente actualizado'));
    add(LoadClientEvent());
  }catch(e){
    emit(ClientError('Error al actualizar cliente${e.toString()}'));
  }
}
Future<void> _onDeleteClient (DeleteClientEvent event, Emitter<ClientState> emit) async{
  emit(ClientLoading());
  try{
    await _clientRepository.eliminarCliente(event.id);
    emit(ClientOperationSuccess('Cliente eliminado correctamente'));
    add(LoadClientEvent());
  }catch(e){
    emit(ClientError('Error al eliminar cliente ${e.toString()}'));
  }
}


}