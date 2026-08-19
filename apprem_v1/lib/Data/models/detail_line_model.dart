
import 'package:apprem_v1/Domain/entities/detail_line.dart';
import 'package:apprem_v1/Data/database/app_database.dart' as db;

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
  /// Mapper desde la clase que genera Drift automáticamente
  factory DetailLineModel.fromDrift(db.DetailLine lines){
    return DetailLineModel(
      id: lines.id, 
      remisionId: lines.remisionId, 
      prodctoId: lines.productoId, 
      nombreProducto: lines.nombreProducto, 
      cantidad: lines.cantidad, 
      precioSugeridoOriginal: lines.precioSugeridoOriginal, 
      precioUnitarioEnEseMomento: lines.precioSugeridoOriginal
      );
  }
  //
  db.DetailLinesCompanion toCompanion(){
    return db.DetailLinesCompanion.insert(
      id: id, 
      remisionId: remisionId, 
      productoId: prodctoId, 
      nombreProducto: nombreProducto, 
      cantidad: cantidad, 
      precioSugeridoOriginal: precioSugeridoOriginal, 
      precioUnitarioEnEseMomento: precioUnitarioEnEseMomento
      );
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