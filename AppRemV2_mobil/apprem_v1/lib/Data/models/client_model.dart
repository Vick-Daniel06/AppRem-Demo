import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/Domain/entities/client.dart';


class ClientModel extends Client {

  const ClientModel({
    required super.id,
    required super.nombre,
    required super.ubicacionCliente,
  });
/// MAPPER: Convierte un mapa crudo de SQLite (llave-valor) a un Modelo de Dart.
  factory ClientModel.fromDrift(db.Client client){
    return ClientModel(
      id: client.id, 
      nombre: client.nombre, 
      ubicacionCliente: client.ubicacionCliente
      );
  }
  
  db.ClientsCompanion toCompanion(){
    return db.ClientsCompanion.insert(id: id,
     nombre: nombre, 
     ubicacionCliente: ubicacionCliente
     );
  }

/// MAPPER: Convierte una Entidad pura de Dominio a este Modelo de Datos.
  factory ClientModel.fromEntity(Client entity){
    return ClientModel(id: entity.id,
     nombre: entity.nombre,
      ubicacionCliente:entity.ubicacionCliente
      );
  }

}