import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/Data/models/client_model.dart';


class ClientLocalDataSource {

  final db.AppDatabase _database;
  ClientLocalDataSource(this._database);
//Trae los Clientes
  Future<List<ClientModel>> obtenerClientes() async{
    final filas = await _database.select(_database.clients).get();

    return filas.map((fila) => ClientModel(
      id: fila.id,
       nombre: fila.nombre,
        ubicacionCliente: fila.ubicacionCliente))
        .toList();
  }
/// QUERY: Inserta un cliente. Si el ID ya existe, actualiza los campos (Upsert)
/// // Drift usa "Companions" para asegurar que los inserts lleven tipos válidos
//Si el usuario edita un producto existente o agrega uno nuevo, la función detecta si el ID ya existe. Si existe, hace un UPDATE; si no, hace un INSERT.
  Future<void> guardarOActualizarCliente(ClientModel client) async{
    await _database.into(_database.clients).insertOnConflictUpdate(
      db.ClientsCompanion.insert(
        id: client.id,
        nombre: client.nombre,
        ubicacionCliente: client.ubicacionCliente,
      ),
    );
  }
/// QUERY: Elimina un clientes de la tabla mediante su UUID
  Future<void> eliminarCliente(String id) async{
    await (_database.delete(_database.clients)
    ..where((tabla) => tabla.id.equals(id)))
    .go();
  }
}