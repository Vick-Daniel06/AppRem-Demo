import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/Data/models/product_model.dart';

class ProductLocalDataSource {
  final db.AppDatabase _database;

  ProductLocalDataSource(this._database);
/// QUERY: Trae todos los productos guardados en SQLite
  Future<List<ProductModel>> obtenerProductos() async{
    
    final filas = await _database.select(_database.products).get();
    final filasModel = filas.map((l) => ProductModel.fromDrift(l)).toList();

    return filasModel;
  }
/// QUERY: Inserta un producto. Si el ID ya existe, actualiza los campos (Upsert)
  Future<void> guardarOActualizarProducto(ProductModel product) async{

    await _database
    .into(_database.products)
    .insertOnConflictUpdate(product.toCompanion());
  }
/// QUERY: Elimina un producto de la tabla mediante su UUID
  Future<void> eliminarProducto(String id) async{
    await (_database.delete(_database.products)
    ..where((tabla) => tabla.id.equals(id)))
    .go();
  }

}