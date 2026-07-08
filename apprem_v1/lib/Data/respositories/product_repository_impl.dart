import 'package:apprem_v1/data/datasources/product_local_data_source.dart';
import 'package:apprem_v1/data/models/product_model.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';
import 'package:apprem_v1/Domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._localDataSource);

  @override
  Future<List<Product>> obtenerProductos() async{
    return await _localDataSource.obtenerProductos();
  }

  @override
  Future<void>crearProducto(Product product) async{
    //Se traduce la Entidad del Dominio a un model que entienda DataSource
    final model = ProductModel.fromEntity(product);
    await _localDataSource.guardarOActualizarProducto(model);
  }
  @override
  Future<void>actualizarProdcuto(Product product) async{
    final model = ProductModel.fromEntity(product);
    await _localDataSource.guardarOActualizarProducto(model);
  }

  @override
  Future<void>eliminarProducto(String id) async{
    await _localDataSource.eliminarProducto(id);
  }


}
