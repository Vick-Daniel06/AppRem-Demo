import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:equatable/equatable.dart';

class HistorialState extends Equatable {
  final List<Remission> remission;
  final bool hasReachedMax;
  final bool isLoading;
  final String? error;

  const HistorialState({
    this.remission = const [],
    this.hasReachedMax = false,
    this.isLoading = false,
    this.error,
  });

  HistorialState copyWith({
    List<Remission>? remission,
    bool? hasReachedMax,
    bool? isLoading,
    String? error,
  }) {
    return HistorialState(
      remission: remission ?? this.remission,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [remission, hasReachedMax, isLoading, error];
}
