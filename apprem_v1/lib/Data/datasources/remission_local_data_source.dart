import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/Data/models/remission_model.dart';
import 'package:apprem_v1/Data/models/detail_line_model.dart';
import 'package:drift/drift.dart';

class RemissionLocalDataSource {
  final db.AppDatabase _database;

  RemissionLocalDataSource(this._database);
/// QUERY: Trae todo el historial de remisiones con sus líneas de detalle cargadas
Future<List<RemissionModel>> obtenerHistorialRemisiones() async {
    // Trae todas las cabeceras ordenadas por fecha (la más reciente primero)
    final headerQuery = _database.select(_database.remissions)
      ..orderBy([(t) => OrderingTerm(expression: t.fechaCreacion, mode: OrderingMode.desc)]);
    
    final rawHeader = await headerQuery.get();
    final List<RemissionModel> history = [];

    // Por cada cabecera, buscamos sus renglones correspondientes
    for (var headers in rawHeader) {
      final queryLineas = _database.select(_database.detailLines)
        ..where((t) => t.remisionId.equals(headers.id));
      
      final rawLines = await queryLineas.get();

      // Convierte las filas de las líneas a DetailLineModel
      final lineasModel = rawLines.map((l) => DetailLineModel(
        id: l.id,
        remisionId: l.remisionId,
        prodctoId: l.productoId,
        nombreProducto: l.nombreProducto,
        cantidad: l.cantidad,
        precioSugeridoOriginal: l.precioSugeridoOriginal,
        precioUnitarioEnEseMomento: l.precioUnitarioEnEseMomento,
      )).toList();

      // Se une la cabecera con sus líneas usando RemissionModel
      history.add(RemissionModel.fromSqlite(headers.toJson(), lineasModel));
    }

    return history;
  }

/// TRANSACTION: Guarda la remisión y sus líneas de manera atómica (Todo o nada)
  Future<void> guardarRemision(RemissionModel remission) async{
    // .transaction() asegura la integridad de la base de datos
    await _database.transaction(() async{
      //Se convierte el modelo a lo que entiende Drift
      await _database.into(_database.remissions).insert(
        db.RemissionsCompanion.insert(
          id: remission.id,
          folio: remission.folio,
          fechaCreacion: remission.fechaCreacion,
          nombreVendedor: remission.nombreVendedor,
          nombreCliente: remission.nombreCliente,
          firmaPath: remission.firmaPath,
          fotoEvidenciaPath: Value(remission.fotoEvidenciaPath),// Value() permite nulos en Drift
          )
      );

      //Inserta cada uino de los renglones de detalle
      for(var lines in remission.detailLines){
        final l = lines as DetailLineModel;

        await _database.into(_database.detailLines).insert(
          db.DetailLinesCompanion.insert(
            id: l.id,
            remisionId: l.remisionId,
            productoId: l.prodctoId,
            nombreProducto: l.nombreProducto,
            cantidad: l.cantidad,
            precioSugeridoOriginal: l.precioSugeridoOriginal,
            precioUnitarioEnEseMomento: l.precioUnitarioEnEseMomento,
          )
        );
      }
    });
  }

  Future<int> obtenerSiguienteFolio() async{
    final quantity = await _database.select(_database.remissions).get();
    return quantity.length + 1;
  }

}