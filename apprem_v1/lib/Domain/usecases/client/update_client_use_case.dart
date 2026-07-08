
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';

class UpdateClientUseCase {
  final ClientRepository _repository;
  UpdateClientUseCase(this._repository);

  Future<void>call(Client client) async{
    if(client.nombre.trim().isEmpty){
      throw Exception('El nombre no pude quedar vacio');
    }
    await _repository.actualizarCliente(client);
  }
}