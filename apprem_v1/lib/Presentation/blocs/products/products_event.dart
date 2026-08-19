
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}
class LoadProductsEvent extends ProductsEvent{}
 class AddProductEvent extends ProductsEvent{
  final Product product;
  const AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
 }

 class UpdateProductEvent extends ProductsEvent{
  final Product product;
  const UpdateProductEvent(this.product);
  @override
  List<Object?> get props => [product];
 }

 class DeleteProductEvent extends ProductsEvent {
  final String id;
  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}