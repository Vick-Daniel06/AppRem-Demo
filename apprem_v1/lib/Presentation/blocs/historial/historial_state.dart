import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:equatable/equatable.dart';

abstract class HistorialState extends Equatable{
  const HistorialState();

  @override
  List<Object?> get props => [];
}
class HistorialInitial extends HistorialState {} 

class HistorialLoad extends HistorialState{}

class HistorialReady extends HistorialState{
  final List<Remission> remission;
  const HistorialReady(this.remission);

  @override
  List<Object?> get props => [remission];
}
class HistorialError extends HistorialState{
  final String message;
  const HistorialError(this.message);

  @override
  List<Object?>get props =>[message];
}
