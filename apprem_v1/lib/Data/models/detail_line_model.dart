
import 'package:apprem_v1/Domain/entities/detail_line.dart';

class DetailLineModel extends DetailLine {

  const DetailLineModel({
    required super.id,
    required super.remisionId,
    required super.prodctoId,
    required super.nombreProducto,
    required super.cantidad,
    required super.precioSugeridoOriginal,
    required super.precioUnitarioEnEseMomento,
    
  });
  /// MAPPER: Convierte un mapa crudo de SQLite (llave-valor) a un Modelo de Dart.
  factory DetailLineModel.fromSqlite(Map<String, dynamic> json){
    return DetailLineModel(id: json['id'] as String,
     remisionId: json['remision_id'] as String,
      prodctoId: json['producto_id'] as String,
       nombreProducto: json['nombre_producto'] as String,
        cantidad: json['cantidad'] as int,
        precioSugeridoOriginal: (json['precio_sugerido_original'] as num).toDouble(),
        precioUnitarioEnEseMomento: (json['precio_unitario_en_ese_momento'] as num).toDouble(),
        );
  }
/// MAPPER: Convierte este Modelo a un formato que SQLite entiende para poder guardarlo.
  Map<String, dynamic> toSqlite(){
    return{
      'id': id,
      'remision_id': remisionId,
      'producto_id': prodctoId,
      'nombre_producto': nombreProducto,
      'cantidad': cantidad,
      'precio_sugerido_original': precioSugeridoOriginal,
      'precio_unitario_en_ese_momento': precioUnitarioEnEseMomento,
    };
  }
/// MAPPER: Convierte una Entidad pura de Dominio a este Modelo de Datos.
  factory DetailLineModel.fromEntity(DetailLine entity){
    return DetailLineModel(id: entity.id,
     remisionId:entity.remisionId,
      prodctoId: entity.prodctoId,
       nombreProducto: entity.nombreProducto,
        cantidad: entity.cantidad,
         precioSugeridoOriginal: entity.precioSugeridoOriginal,
          precioUnitarioEnEseMomento: entity.precioUnitarioEnEseMomento,
          );
  }

}