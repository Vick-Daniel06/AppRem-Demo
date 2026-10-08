

import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';
import 'package:apprem_v1/Domain/usecases/product/delete_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/save_product_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_event.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductsEvent, ProductState> {
  final ProductRepository _productRepository;
  final SaveProductUseCase _saveProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  ProductBloc({
    required SaveProductUseCase saveProductUseCase,
    required ProductRepository productRepository,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _productRepository = productRepository,
        _saveProductUseCase = saveProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.obtenerProductos();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Error al cargar productos: ${e.toString()}'));
    }
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _saveProductUseCase(event.product);
      emit(const ProductOperationSuccess('Producto guardado con éxito'));
      add(LoadProductsEvent()); // Recarga la lista automáticamente tras guardar
    } catch (e) {
      emit(ProductError('Error al guardar el producto: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _productRepository.actualizarProdcuto(event.product);
      emit(const ProductOperationSuccess('Producto actualizado con éxito'));
      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductError('Error al actualizar el producto: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _deleteProductUseCase(event.id);
      emit(const ProductOperationSuccess('Producto eliminado con éxito'));
      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductError('Error al eliminar el producto: ${e.toString()}'));
    }
  }


}