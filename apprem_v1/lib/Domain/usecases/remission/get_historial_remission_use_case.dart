
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class GetHistorialRemissionUseCase {
  final RemissionRepository _repository;
  GetHistorialRemissionUseCase(this._repository);

  Future<List<Remission>> call() async {
    return await _repository.obtenerHistorialDeRemisiones();
  }
}