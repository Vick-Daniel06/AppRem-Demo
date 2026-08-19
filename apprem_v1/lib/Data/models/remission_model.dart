
import 'package:apprem_v1/Data/models/detail_line_model.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:drift/drift.dart';

class RemissionModel extends Remission {

const RemissionModel({
    required super.id,
    required super.folio,
    required super.fechaCreacion,
    required super.nombreVendedor,
    required super.nombreCliente,
    required super.firmaPath,
    required super.fotoEvidenciaPath,
    required super.detailLines,
});
//Mapper desde la clase que genera Drift automáticamente
factory RemissionModel.fromDrift(db.Remission header, List<DetailLineModel> lines){
  return RemissionModel(
    id: header.id,
    folio: header.folio,
    fechaCreacion: header.fechaCreacion, 
    nombreVendedor: header.nombreVendedor, 
    nombreCliente: header.nombreCliente, 
    firmaPath: header.firmaPath, 
    fotoEvidenciaPath: header.fotoEvidenciaPath, 
    detailLines: lines,
    );
}
//maper para el modelo a lo que Drift necesita
db.RemissionsCompanion toCompanion(){
  return db.RemissionsCompanion.insert(
    id: id, 
    folio: folio, 
    fechaCreacion: fechaCreacion, 
    nombreVendedor: nombreVendedor, 
    nombreCliente: nombreCliente, 
    firmaPath: firmaPath,
    fotoEvidenciaPath: Value(fotoEvidenciaPath)
    );
}

  // Mapper desde entidad
  factory RemissionModel.fromEntity(Remission entity) {
    return RemissionModel(
      id: entity.id,
      folio: entity.folio,
      fechaCreacion: entity.fechaCreacion,
      nombreVendedor: entity.nombreVendedor,
      nombreCliente: entity.nombreCliente,
      firmaPath: entity.firmaPath,
      fotoEvidenciaPath: entity.fotoEvidenciaPath,
      detailLines: entity.detailLines.map((e) => DetailLineModel.fromEntity(e)).toList(),
    );
  }

}