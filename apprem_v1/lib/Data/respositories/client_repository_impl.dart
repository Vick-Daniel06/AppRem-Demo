
import 'package:apprem_v1/Data/datasources/client_local_data_source.dart';
import 'package:apprem_v1/Data/models/client_model.dart';
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource _localDataSource;

  ClientRepositoryImpl(this._localDataSource);

  @override
  Future<List<Client>>obtenerClientes() async{
    return await _localDataSource.obtenerClientes();
  }
  @override
  Future<void> crearCliente(Client client) async{
    //Se convierte la Entidad a un Model que DataSource pueda entender.
    final model = ClientModel.fromEntity(client);
    await _localDataSource.guardarOActualizarCliente(model);
  }
  @override
  Future<void>actualizarCliente(Client client) async{
    final model = ClientModel.fromEntity(client);
    await _localDataSource.guardarOActualizarCliente(model);
  }
  @override
  Future<void> eliminarCliente(String id) async{
    await _localDataSource.eliminarCliente(id);
  }

}