
import 'package:apprem_v1/Domain/core/result.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';


abstract class RemissionRepository {

  Future<Result<()>> crearRemision(Remission remission);

  Future <Result<List<Remission>>> obtenerHistorialDeRemisiones(
    {
    required int limit,
    required int offset,
  }
  );
  
/// Consulta la base de datos para calcular el consecutivo del folio (MAX(folio) + 1).
  Future<String>obtenerSiguienteFolio();

  Future<Remission?> obtenerRemisionById(String id);

}