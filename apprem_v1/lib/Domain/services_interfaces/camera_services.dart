import 'package:apprem_v1/Domain/core/result.dart';

abstract class CameraServices {
  /// Abre la cámara nativa del dispositivo, captura la fotografía de evidencia,
  /// la comprime para optimizar almacenamiento y la guarda en un directorio seguro.
  /// Retorna un [String] con la ruta local del archivo guardado, 
  /// o [null] si el usuario canceló la captura.
  Future<Result<String>> capturaFotoEvidencia();
}