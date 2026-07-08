
import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';

class DeleteClientUseCase {
  final ClientRepository _repository;
  DeleteClientUseCase(this._repository);

  Future<void>call(String id) async{
    await _repository.eliminarCliente(id);
  }
}