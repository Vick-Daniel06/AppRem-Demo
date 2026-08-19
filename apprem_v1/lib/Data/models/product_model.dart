import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Data/database/app_database.dart' as db;

class ProductModel extends Product{

const ProductModel({
  required super.id,
  required super.nombre,
  required super.pesoKg,
  required super.precioSugerido,
});
/// MAPPER:
/// util para leer datos de tablas
factory ProductModel.fromDrift(db.Product product){
  return ProductModel(
    id: product.id, 
    nombre: product.nombre, 
    pesoKg: product.pesoKg, 
    precioSugerido: product.precioSugerido
    );
}
db.ProductsCompanion toCompanion(){
  return db.ProductsCompanion.insert(id: id,
   nombre: nombre, 
   pesoKg: pesoKg, 
   precioSugerido: precioSugerido
   );
}

/// MAPPER: Convierte una Entidad pura de Dominio a este Modelo de Datos.
  /// Útil cuando el repositorio recibe un Product del Dominio y necesita guardarlo.
factory ProductModel.fromEntity(Product entity){
  return ProductModel(id:entity.id,
   nombre: entity.nombre,
    pesoKg: entity.pesoKg,
     precioSugerido: entity.precioSugerido
     );
}

}