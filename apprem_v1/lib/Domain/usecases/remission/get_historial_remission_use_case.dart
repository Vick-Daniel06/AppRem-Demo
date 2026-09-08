
import 'package:apprem_v1/Domain/core/result.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class GetHistorialRemissionUseCase {
  final RemissionRepository _repository;
  GetHistorialRemissionUseCase(this._repository);

  Future<Result<List<Remission>>> call({required int limit, required int offset}) async {
    return await _repository.obtenerHistorialDeRemisiones(limit: limit, offset: offset);
  }
}