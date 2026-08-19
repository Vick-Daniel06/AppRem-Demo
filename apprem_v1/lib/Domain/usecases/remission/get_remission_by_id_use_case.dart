
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class GetRemissionByIdUseCase {
  final RemissionRepository _repository;
  GetRemissionByIdUseCase(this._repository);

  Future<Remission?> call(String id) async{
    if(id.trim().isEmpty){
      throw Exception('El ID de la remision o puede estar vacio');
    }
    return await _repository.obtenerRemisionById(id);
  }
}