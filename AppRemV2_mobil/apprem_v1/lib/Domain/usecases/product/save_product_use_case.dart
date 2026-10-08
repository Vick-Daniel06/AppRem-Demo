
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';

class SaveProductUseCase {
  final ProductRepository _repository;

  SaveProductUseCase(this._repository);

  Future<void>call(Product product) async{
    if(product.nombre.trim().isEmpty){
      throw Exception('El nombre del producto no puede estar vacio');
    }
    await _repository.crearProducto(product);
  }
}