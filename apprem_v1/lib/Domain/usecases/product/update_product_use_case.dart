
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository _repository;
  UpdateProductUseCase(this._repository);

  Future<void>call(Product product) async{
    
    await _repository.actualizarProdcuto(product);
  }
}