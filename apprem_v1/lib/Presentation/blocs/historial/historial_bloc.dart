import 'package:apprem_v1/Domain/core/result.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/usecases/remission/get_historial_remission_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_event.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistorialBloc extends Bloc<HistorialEvent, HistorialState> {
  final GetHistorialRemissionUseCase _getHistorialRemissionUseCase;
  static const int _limit = 10;

  HistorialBloc({
    required GetHistorialRemissionUseCase getHistorialRemissionUseCase
  }) : _getHistorialRemissionUseCase = getHistorialRemissionUseCase,
  super(const HistorialState()){
    on<GetHistoryInitial>(_onCargarInicial);
    on<GetNextPage>(_onCargarSiguiente);
  }

  Future<void> _onCargarInicial(
    GetHistoryInitial event,
    Emitter<HistorialState> emit
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await _getHistorialRemissionUseCase(limit: _limit, offset: 0);

      if (result is Success<List<Remission>>) {
        final list = result.data;
      emit(state.copyWith(
          remission: list,
          hasReachedMax: list.length < _limit,
        isLoading: false,
      ));
      } else if (result is Failure) {
        final failure = result as Failure;
      emit(state.copyWith(
          error: failure.message,
        isLoading: false,
      ));
      } else {

    emit(state.copyWith(
          error: 'Error de tipo: Se recibió un resultado desconocido',
      isLoading: false,
    ));
  }
    } catch (e) {
      emit(state.copyWith(
        error: 'Ocurrio un erro inesperado: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onCargarSiguiente(
    GetNextPage event,
    Emitter<HistorialState> emit
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    try {
      final currentOffset = state.remission.length;
      final result = await _getHistorialRemissionUseCase(limit: _limit, offset: currentOffset);

      if (result is Success<List<Remission>>) {
        final newList = result.data;
        emit(state.copyWith(
          remission: List.of(state.remission)..addAll(newList),
          hasReachedMax: newList.length < _limit,
          isLoading: false,
        ));
      } else if (result is Failure) {
        final failure = result as Failure;
        emit(state.copyWith(
          error: failure.message,
          isLoading: false,
        ));
      } else {
        // Caso de escape
        emit(state.copyWith(
          error: 'Error inesperado en la carga de página',
          isLoading: false,
        ));
      }
    }catch (e) {
      emit(state.copyWith(
        error: 'Error al cargar mas registros $e',
        isLoading: false,
      ));
    }
  }
}