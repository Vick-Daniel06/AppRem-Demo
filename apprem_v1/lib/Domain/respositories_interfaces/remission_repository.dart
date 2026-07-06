
import 'package:apprem_v1/Domain/entities/remission.dart';

abstract class RemissionRepository {

  Future<void> crearRemision(Remission remission);

  Future<List<Remission>> obtenerHistorialDeRemisiones();
  
/// Consulta la base de datos para calcular el consecutivo del folio (MAX(folio) + 1).
  Future<String>obtenerSiguienteFolio();

}