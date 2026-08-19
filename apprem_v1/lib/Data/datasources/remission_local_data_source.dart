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
    /*final headerQuery = _database.select(_database.remissions)
      ..orderBy([(t) => OrderingTerm(expression: t.fechaCreacion, mode: OrderingMode.desc)]);*/
    
    final rawHeader = await (_database.select(_database.remissions)
    ..orderBy([(t)=> OrderingTerm(expression: t.fechaCreacion, mode: OrderingMode.desc)]))
    .get()
    ;
    final List<RemissionModel> history = [];

    // Por cada cabecera, buscamos sus renglones correspondientes
    for (var headers in rawHeader) {
      final rawLines = await (_database.select(_database.detailLines)
      ..where((t)=> t.remisionId.equals(headers.id))).get();

      // Convierte las filas de las líneas a DetailLineModel
      final lineasModel = rawLines.map((l) => DetailLineModel.fromDrift(l)).toList();

      // Se une la cabecera con sus líneas usando RemissionModel
      history.add(RemissionModel.fromDrift(headers, lineasModel));

    }

    return history;
  }

/// TRANSACTION: Guarda la remisión y sus líneas de manera atómica (Todo o nada)
  Future<void> guardarRemision(RemissionModel remission) async{
    // .transaction() asegura la integridad de la base de datos
    await _database.transaction(() async{
      //Se convierte el modelo a lo que entiende Drift
      await _database.into(_database.remissions).insert(remission.toCompanion());

      //Inserta cada uino de los renglones de detalle
      for(var lines in remission.detailLines){
        final lineModel = lines is DetailLineModel
        ? lines : DetailLineModel.fromEntity(lines);

        await _database.into(_database.detailLines).insert(lineModel.toCompanion());
      }
    });
  }

  Future<int> obtenerSiguienteFolio() async{
    final quantity = await _database.select(_database.remissions).get();
    return quantity.length + 1;
  }

  Future<RemissionModel?> getRemissionById(String id) async{
    final remissionNow = await (_database.select(_database.remissions)
    ..where((tbl) => tbl.id.equals(id))
    ).getSingleOrNull();
    if(remissionNow == null) return null;

    final detailRow = await (_database.select(_database.detailLines)
    ..where((d) => d.remisionId.equals(id))).get();

    final linesModel = detailRow.map((l) => DetailLineModel.fromDrift(l)).toList();

    return RemissionModel.fromDrift(remissionNow, linesModel);
  }

}