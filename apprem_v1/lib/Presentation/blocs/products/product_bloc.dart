

import 'package:apprem_v1/Domain/usecases/product/delete_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/get_products_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/save_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/update_product_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_event.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductsEvent, ProductState> {
 final GetProductsUseCase _getProductsUseCase;
  final SaveProductUseCase _saveProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  ProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required SaveProductUseCase saveProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _saveProductUseCase = saveProductUseCase,
        _updateProductUseCase = updateProductUseCase,
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
      final products = await _getProductsUseCase();
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
      await _updateProductUseCase(event.product);
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