
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class RemformEvent extends Equatable {
  const RemformEvent();
  @override
  List<Object?> get props => [];
}
/// Disparado al abrir la pantalla de creación.
/// Carga catálogos de productos, clientes y calcula el siguiente folio.
class InitializeCreator extends RemformEvent{}
/// Cambia el cliente seleccionado para la remisión actual.
class ClientsSelected extends RemformEvent{
  final Client client;
  const ClientsSelected(this.client);
  @override
  List<Object?> get props => [client];
}
/// Agrega una línea de producto al borrador o incrementa su cantidad si ya existe.
class ProductAdded extends RemformEvent{
  final Product product;
  final int amount; 
  final double unitPrice;
  const ProductAdded(this.product, this.amount, this.unitPrice);

  @override
  List<Object?> get props => [product, amount, unitPrice];
}
/// Elimina una línea de producto del detalle.
class ProductDeleted extends RemformEvent{
  final String productID;
  const ProductDeleted(this.productID);

  @override
  List<Object?> get props => [productID];
}
/// Dispara el proceso final de validación y persistencia en SQLite.
class SaveRemissionPressed extends RemformEvent{
  final String signaturePath;
  final String? evidanceFotoPath;

  const SaveRemissionPressed({required this.signaturePath, this.evidanceFotoPath});

  @override
  List<Object?> get props => [signaturePath, evidanceFotoPath];
}