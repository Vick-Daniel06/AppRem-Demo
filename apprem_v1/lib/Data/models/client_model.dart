
import 'package:apprem_v1/Domain/entities/client.dart';


class ClientModel extends Client {

  const ClientModel({
    required super.id,
    required super.nombre,
    required super.ubicacionCliente,
  });
/// MAPPER: Convierte un mapa crudo de SQLite (llave-valor) a un Modelo de Dart.
  factory ClientModel.fromSqlite(Map<String,dynamic> json){
    return ClientModel(id: json['id'] as String,
     nombre: json['nombre'] as String,
      ubicacionCliente: json['ubicacion_cliente'] as String
      );
  }
/// MAPPER: Convierte este Modelo a un formato que SQLite entiende para poder guardarlo.
  Map<String, dynamic> toSqlite(){
    return{
      'id': id,
      'nombre': nombre,
      'ubicacion_cliente': ubicacionCliente,
    };
  }
/// MAPPER: Convierte una Entidad pura de Dominio a este Modelo de Datos.
  factory ClientModel.fromEntity(Client entity){
    return ClientModel(id: entity.id,
     nombre: entity.nombre,
      ubicacionCliente:entity.ubicacionCliente
      );
  }

}