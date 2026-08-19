import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/Data/models/client_model.dart';


class ClientLocalDataSource {

  final db.AppDatabase _database;
  ClientLocalDataSource(this._database);
//Trae los Clientes
  Future<List<ClientModel>> obtenerClientes() async{
    final filas = await _database.select(_database.clients).get();
    return filas.map((fila) => ClientModel.fromDrift(fila)).toList();

  }
/// QUERY: Inserta un cliente. Si el ID ya existe, actualiza los campos (Upsert)
  Future<void> guardarOActualizarCliente(ClientModel client) async{
    await _database.into(_database.clients).insertOnConflictUpdate(client.toCompanion());
  }
/// QUERY: Elimina un clientes de la tabla mediante su UUID
  Future<void> eliminarCliente(String id) async{
    await (_database.delete(_database.clients)
    ..where((tabla) => tabla.id.equals(id)))
    .go();
  }
}