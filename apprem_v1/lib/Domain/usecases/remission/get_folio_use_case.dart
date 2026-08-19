
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class GetFolioUseCase {
  final RemissionRepository _repository;
  GetFolioUseCase(this._repository);
  Future<String> call() async{
    
    return await _repository.obtenerSiguienteFolio();
  }
}