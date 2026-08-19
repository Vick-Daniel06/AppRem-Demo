import 'package:apprem_v1/Domain/usecases/remission/get_historial_remission_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_event.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistorialBloc extends Bloc<HistorialEvent, HistorialState> {
  final GetHistorialRemissionUseCase _getHistorialRemissionUseCase;

  HistorialBloc({
    required GetHistorialRemissionUseCase getHistorialRemissionUseCase
  }) : _getHistorialRemissionUseCase = getHistorialRemissionUseCase,
  super(HistorialInitial()){
    //Mapea el evento con su respectiva logica
    on<GetLogHistory>(_onGetLogsHistory);
  }

  Future<void> _onGetLogsHistory(
    GetLogHistory event,
    Emitter<HistorialState> emit,
  ) async{
    //Se le dice a la UI:
    //muestra un spinner de carga
    emit(HistorialLoad());

    try{
      //Caso de uso del domino
      final remissions = await _getHistorialRemissionUseCase();
      //Se emite el estado de exito con los datos
      emit(HistorialReady(remissions));
    }catch(e){
      //Si algo falla, emitir error para congelar pantalla
      emit(HistorialError('Nos e pudieron cargar las remisiones: ${e.toString()}'));
    }

  }
}