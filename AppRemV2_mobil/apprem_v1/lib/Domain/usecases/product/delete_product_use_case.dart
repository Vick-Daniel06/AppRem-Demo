
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _repository;
  DeleteProductUseCase(this._repository);

  Future<void>call(String id) async{
    if(id.isEmpty){
      throw Exception('ID no encontrado');
    }

    await _repository.eliminarProducto(id);
  }
}