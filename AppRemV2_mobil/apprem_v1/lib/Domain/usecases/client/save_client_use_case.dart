
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';

class SaveClientUseCase {
  final ClientRepository _repository;
  SaveClientUseCase(this._repository);
  
  Future<void>call(Client client) async{
    if(client.nombre.trim().isEmpty){
      throw Exception('El nombre es obligatorio');
    }
    await _repository.crearCliente(client);
  }
}