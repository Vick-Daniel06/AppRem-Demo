
import 'package:equatable/equatable.dart';

abstract class HistorialEvent extends Equatable {
  const HistorialEvent();

  @override
  List<Object?> get props => [];
}
//Se dispara cuando la pantalla se abre por primera vez o cuando el usario haga un "pull-to-refresh"
class GetLogHistory extends HistorialEvent{}