
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:equatable/equatable.dart';

//EQUATABLE AL COMPARA OBJETOS, SI HAY UN ERROR Y DA OTRA VEZ EL ERROR YA NO LO MUESTRA LA SEGUNDA VEZ POR QUE CREE QUE ES LO MISMO
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