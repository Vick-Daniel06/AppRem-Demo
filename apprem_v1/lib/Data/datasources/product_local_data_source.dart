import 'package:apprem_v1/Data/database/app_database.dart' as db;
import 'package:apprem_v1/data/models/product_model.dart';

class ProductLocalDataSource {
  final db.AppDatabase _database;

  ProductLocalDataSource(this._database);
/// QUERY: Trae todos los productos guardados en SQLite
  Future<List<ProductModel>> obtenerProductos() async{
    final filas = await _database.select(_database.products).get();

    return filas.map((fila) => ProductModel(
      id: fila.id,
      nombre: fila.nombre,
      pesoKg: fila.pesoKg,
      precioSugerido: fila.precioSugerido,
    )).toList();
  }
/// QUERY: Inserta un producto. Si el ID ya existe, actualiza los campos (Upsert)
  Future<void> guardarOActualizarProducto(ProductModel product) async{
// Drift usa "Companions" para asegurar que los inserts lleven tipos válidos
//Si el usuario edita un producto existente o agrega uno nuevo, la función detecta si el ID ya existe. Si existe, hace un UPDATE; si no, hace un INSERT.
    await _database.into(_database.products).insertOnConflictUpdate(
      db.ProductsCompanion.insert(
        id: product.id,
        nombre: product.nombre,
        pesoKg: product.pesoKg,
        precioSugerido: product.precioSugerido,
      ),
    );
  }
/// QUERY: Elimina un producto de la tabla mediante su UUID
  Future<void> eliminarProducto(String id) async{
    await (_database.delete(_database.products)
    ..where((tabla) => tabla.id.equals(id)))
    .go();
  }

}