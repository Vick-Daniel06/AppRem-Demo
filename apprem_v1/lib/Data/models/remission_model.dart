
import 'package:apprem_v1/Data/models/detail_line_model.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';

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

factory RemissionModel.fromSqlite(Map<String, dynamic> json, List<DetailLineModel> lines){
return RemissionModel(
      id: json['id'] as String,
      folio: json['folio'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String), // SQLite guarda fechas como String ISO8601
      nombreVendedor: json['nombre_vendedor'] as String,
      nombreCliente: json['nombre_cliente'] as String,
      firmaPath: json['firma_path'] as String,
      fotoEvidenciaPath: json['foto_evidencia_path'] as String?,
      detailLines: lines, //la lista de detailLines se guarda aqui.
    );
}
// Mapper para guardar en SQLite (Solo la cabecera)
  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'folio': folio,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'nombre_vendedor': nombreVendedor,
      'nombre_cliente': nombreCliente,
      'firma_path': firmaPath,
      'foto_evidencia_path': fotoEvidenciaPath,
    };
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