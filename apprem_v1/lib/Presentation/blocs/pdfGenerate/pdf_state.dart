
import 'package:equatable/equatable.dart';

abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object?> get props => [];
}
class PdfInitial extends PdfState{}

class PdfLoadingState extends PdfState{}

class PdfSuccessState extends PdfState{
  final String path;
  const PdfSuccessState(this.path);

  @override
  List<Object?> get props => [path];
}
class PdfErrorState extends PdfState{
  final String message;
  const PdfErrorState(this.message);
  @override
  List<Object?> get props => [message];
}