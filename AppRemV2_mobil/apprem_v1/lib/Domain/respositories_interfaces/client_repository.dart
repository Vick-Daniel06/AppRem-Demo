
import 'package:apprem_v1/Domain/entities/client.dart';

abstract class ClientRepository {

  Future<void> crearCliente(Client client);

  Future<List<Client>> obtenerClientes();

  Future<void> actualizarCliente(Client client);

  Future<void> eliminarCliente(String id);
}