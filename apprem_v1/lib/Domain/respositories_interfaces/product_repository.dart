import 'package:apprem_v1/Domain/entities/product.dart';

abstract class ProductRepository {
  
  Future<void> crearProducto(Product product);

  Future<List<Product>> obtenerProductos();

  Future<void> actualizarProdcuto(Product product);

  Future<void> eliminarProducto(String id);

}