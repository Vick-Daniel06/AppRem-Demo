
import 'package:apprem_v1/Domain/entities/detail_line.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/usecases/client/get_clients_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/get_products_use_case.dart';
import 'package:apprem_v1/Domain/usecases/remission/create_remission_use_case.dart';
import 'package:apprem_v1/Domain/usecases/remission/get_folio_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/creator_state.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/remForm_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class RemformBloc extends Bloc<RemformEvent, RemFormState> {

  final GetProductsUseCase _getProductsUseCase;
  final GetClientsUseCase _getClientsUseCase;
  final GetFolioUseCase _getFolioUseCase;
  final CreateRemissionUseCase _createRemissionUseCase;
  final _uuid = const Uuid();

  RemformBloc({
    required GetProductsUseCase getProduct,
    required GetClientsUseCase getClient,
    required GetFolioUseCase getFolio,
    required CreateRemissionUseCase createRem,
  }) : _getProductsUseCase = getProduct,
  _getClientsUseCase = getClient,
  _getFolioUseCase = getFolio,
  _createRemissionUseCase = createRem,
  super(RemFormState.initial()){
    on<InitializeCreator>(_onInitizeCreator);
    on<ClientsSelected>(_onClientSelected);
    on<ProductAdded>(_onProductAdded);
    on<ProductDeleted>(_onProductDeleted);
    on<SaveRemissionPressed>(_onSaveRemissionPressed);
  }

  //Cragar los catalogos al abir pantalla
  Future<void> _onInitizeCreator( InitializeCreator event, Emitter<RemFormState> emit,) async{
    emit(state.copyWith(status: FormStatus.catalogsloading));
    try{
      final products = await _getProductsUseCase();
      final clients = await _getClientsUseCase();
      final nextFolio = await _getFolioUseCase();

      emit(state.copyWith(
        status: FormStatus.ready,
        productCatalog: products,
        clientCatalog: clients,
        folio: nextFolio,
      ));
    }catch(e){
      emit(state.copyWith(
        status: FormStatus.error,
        errorMessage: 'Error al iniciar formulario: ${e.toString()}',
      ));
    }
  }
  //Seleccion de cliente
  void _onClientSelected(ClientsSelected event, Emitter<RemFormState> emit){
    emit(state.copyWith(clientSelected: event.client));
  }

  //Agregar producto al detalle y recalcuar el total
  void _onProductAdded(ProductAdded event, Emitter<RemFormState> emit){
    final actualLines = List<DetailLine>.from(state.detailLine);
    //Verificacion si el producto ya estaba agregado para solo incrementar la cantidad
    final existingIndex = actualLines.indexWhere(
      (line) => line.prodctoId == event.product.id,
    );
    if(existingIndex != -1){
      final oldLine = actualLines[existingIndex];
      final newAmount = oldLine.cantidad + event.amount;

      actualLines[existingIndex] = DetailLine(
        id: oldLine.id,
        remisionId: oldLine.remisionId,
        prodctoId: oldLine.prodctoId,
        nombreProducto: oldLine.nombreProducto,
        cantidad: newAmount.toInt(),
        precioSugeridoOriginal: oldLine.precioSugeridoOriginal,
        precioUnitarioEnEseMomento: oldLine.precioUnitarioEnEseMomento,
      );
    }else{
      //Si es un productro nuevo, se crea las lineas desde cero
      actualLines.add(DetailLine(id: _uuid.v4(),
       remisionId: '',
        prodctoId: event.product.id,
         nombreProducto: event.product.nombre,
          cantidad: event.amount.toInt(),
           precioSugeridoOriginal: event.product.precioSugerido,
            precioUnitarioEnEseMomento: event.product.precioSugerido,// Por defecto se vende al precio sugerido
            ));
    }

    emit(state.copyWith(
      detailLine: actualLines,
     
    ));
  }

  //Elimina el producto detalle y recalcula el total
  void _onProductDeleted(ProductDeleted event, Emitter<RemFormState>emit){
    final actualLines = List<DetailLine>.from(state.detailLine)
    ..removeWhere((line)=> line.prodctoId == event.productID);

    emit(state.copyWith(
      detailLine: actualLines,
    ));
  }

  //Guardar todo de forma automatica en SQLite
  Future<void> _onSaveRemissionPressed(SaveRemissionPressed event, Emitter<RemFormState> emit)async{
    if(state.clientSelected == null){
      emit(state.copyWith(
        status: FormStatus.error,
        errorMessage: 'Debes seleccionar un cliente anes de guardar'
      ));
      return;
    }
    if(state.detailLine.isEmpty){
      emit(state.copyWith(
        status: FormStatus.error,
        errorMessage: 'No puedes guardar una remision sin productos'
      ));
      return;
    }
    emit(state.copyWith(status: FormStatus.saving));

    try{
      final remissionId = _uuid.v4();
      final linkedLines = state.detailLine.map((line){
        return DetailLine(id: line.id,
         remisionId: remissionId,
          prodctoId: line.prodctoId,
           nombreProducto: line.nombreProducto,
            cantidad: line.cantidad,
             precioSugeridoOriginal: line.precioSugeridoOriginal,
              precioUnitarioEnEseMomento: line.precioUnitarioEnEseMomento
              );
      }).toList();

      //Entidad de dominio lista para ser insertada
      final newRemission = Remission(id: remissionId,
       folio: state.folio,
        fechaCreacion: DateTime.now(),
         nombreVendedor: 'Vendedor local', //Para la V2 se tomara del login
          nombreCliente: state.clientSelected!.nombre,
           detailLines: linkedLines,
            firmaPath: event.signaturePath,
             fotoEvidenciaPath: event.evidanceFotoPath
             );
             //Se guarda fisicamente en Sqlite usando el caso de uso
             await _createRemissionUseCase(newRemission);
             emit(state.copyWith(status: FormStatus.success, savedRemissionId: remissionId));
    }catch(e){
      emit(state.copyWith(status: FormStatus.error,
      errorMessage: 'Error al guardar la remision ${e.toString()}'));
    }
  }
}