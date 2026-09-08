
import 'package:apprem_v1/Domain/core/result.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';

abstract class PdfServices {
/// Toma los datos de la remisión, genera el documento PDF 
  /// y dispara el menú nativo para compartirlo (WhatsApp)
  Future<Result<String>> generarPdfYCompartir(Remission remission);
}