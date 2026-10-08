
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/entities/detail_line.dart';
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:equatable/equatable.dart';
enum FormStatus{inicial, catalogsloading, ready, saving, success, error}

class RemFormState extends Equatable{
  final FormStatus status;
  final String folio;
  final String? savedRemissionId;
  final Client? clientSelected;
  final List<DetailLine> detailLine;
  double get totalamount => detailLine.fold<double>(0.0, (sum, line) => sum+line.subtotal);

  //Catalogos auxiliares
  final List<Product> productCatalog;
  final List<Client> clientCatalog;
  final String? errorMessage;

  const RemFormState({
    required this.status,
    required this.folio,
    this.savedRemissionId,
    this.clientSelected,
    required this.detailLine,
    required this.productCatalog,
    required this.clientCatalog,
    this.errorMessage,
  });
// Estado inicial del formulario vacío
  factory RemFormState.initial(){
    return const RemFormState(
      status: FormStatus.inicial,
      folio: '',
      savedRemissionId: null,
      clientSelected: null,
      detailLine: [],
      productCatalog: [],
      clientCatalog: [],
      errorMessage: null,
    );
  }
  //metodo copyWith para actualizar los campos individuales sin perder los demas
RemFormState copyWith({
  FormStatus? status,
  String? folio,
  String? savedRemissionId,
  Client? clientSelected,
  List<DetailLine>? detailLine,
  double? totalamount,
  List<Product>? productCatalog,
  List<Client>? clientCatalog,
  String? errorMessage,
}){
  return RemFormState(
    status: status ?? this.status,
    folio: folio ?? this.folio,
    savedRemissionId: savedRemissionId ?? this.savedRemissionId,
    clientSelected: clientSelected ?? this.clientSelected,
    detailLine: detailLine ?? this.detailLine,
    productCatalog: productCatalog ?? this.productCatalog,
    clientCatalog: clientCatalog ?? this.clientCatalog,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@override
List<Object?> get props => [
  status,
  folio,
  savedRemissionId,
  clientSelected,
  detailLine,
  productCatalog,
  clientCatalog,
  errorMessage,
];

}
