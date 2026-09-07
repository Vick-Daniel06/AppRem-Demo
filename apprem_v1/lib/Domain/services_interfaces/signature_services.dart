import 'dart:typed_data';

import 'package:apprem_v1/Domain/core/result.dart'; //Lib nativa

abstract class SignatureService {
  /// Toma los bytes de la firma dibujada en la UI, los procesa y los guarda
  /// como un archivo de imagen (.png) en el almacenamiento seguro de la app.
  /// 
  /// Retorna un [String] con la ruta local del archivo de la firma generado.
  Future<Result<String>> guardarFirmaDigital(Uint8List bytesFirma);
}