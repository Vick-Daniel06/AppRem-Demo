
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/services_interfaces/pdf_services.dart';

class GeneratePdfAndShareUseCase {
  final PdfServices _pdfServices;
  GeneratePdfAndShareUseCase(this._pdfServices);

  Future<String?> call(Remission remission) async {
    if(remission.detailLines.isEmpty){
      throw Exception('Nos se puede crear sin Lineas de Detalle');
    }
    if(remission.nombreCliente.isEmpty ){
      throw Exception('Debe de tener un nombre');
    }
    
    return await _pdfServices.generarPdfYCompartir(remission);
  }
}