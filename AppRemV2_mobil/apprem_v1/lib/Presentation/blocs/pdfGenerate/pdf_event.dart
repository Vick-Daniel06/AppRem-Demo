import 'package:equatable/equatable.dart';


abstract class PdfEvent extends Equatable{
  const PdfEvent();
  @override
  List<Object?> get props => [];

}

class GeneratePdfEvent extends PdfEvent{
  final String remissionId;
  const GeneratePdfEvent(this.remissionId);

  @override
  List<Object?> get porps => [remissionId];
}

class SharePdfEvent extends PdfEvent{
  final  String path;
  const SharePdfEvent(this.path);

  @override
  List<Object?> get props => [path];
}