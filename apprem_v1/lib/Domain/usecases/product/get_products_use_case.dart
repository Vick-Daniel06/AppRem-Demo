
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;
  
  GetProductsUseCase(this._repository);

  //Utiliza el metodo call() para que el caso de uso se pueda ejecutar invocando a la clase como si fuera una funcion
  Future<List<Product>> call() async{
    return await _repository.obtenerProductos();
  }
}