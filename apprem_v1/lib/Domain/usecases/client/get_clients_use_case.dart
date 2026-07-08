

import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';

class GetClientsUseCase {
  final ClientRepository _repository;

  GetClientsUseCase(this._repository);
  Future<List<Client>>call() async{
    return await _repository.obtenerClientes();
  }
}