import 'package:apprem_v1/Domain/entities/product.dart';

class ProductModel extends Product{

const ProductModel({
  required super.id,
  required super.nombre,
  required super.pesoKg,
  required super.precioSugerido,
});
/// MAPPER: Convierte un mapa crudo de SQLite (llave-valor) a un Modelo de Dart.
/// util para leer datos de tablas
factory ProductModel.fromSqlite(Map<String, dynamic> json){
  return ProductModel(id: json['id'] as String,
   nombre: json['nombre'] as String,
    pesoKg: (json['peso_kg'] as num).toDouble(),
     precioSugerido:(json['precio_sugerido'] as num).toDouble() 
     );
}
/// MAPPER: Convierte este Modelo a un formato que SQLite entiende para poder guardarlo.
Map<String, dynamic> toSqlite(){
  return{
    'id': id,
    'nombre': nombre,
    'peso_kg': pesoKg,
    'precio_sugerido': precioSugerido,
  };
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