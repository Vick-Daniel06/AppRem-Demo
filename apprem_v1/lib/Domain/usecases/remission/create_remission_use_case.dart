
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class CreateRemissionUseCase {
  final RemissionRepository _repository;

  CreateRemissionUseCase(this._repository);

  Future<void> call(Remission remission) async{
    // Regla de negocio: No se pueden hacer remisiones vacías
    if (remission.detailLines.isEmpty) {
      throw Exception('No se puede guardar una remisión sin productos seleccionados.');
    }

    // Regla de negocio: Validar que el cliente esté asignado obligatoriamente
    if (remission.nombreCliente.trim().isEmpty) {
      throw Exception('Es obligatorio asignar un cliente a la remisión.');
    }

    if(remission.firmaPath.isEmpty){
      throw Exception('Es obligatorio la firma');
    }

    await _repository.crearRemision(remission);
  }
}