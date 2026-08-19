
import 'package:apprem_v1/Data/datasources/remission_local_data_source.dart';
import 'package:apprem_v1/Data/models/detail_line_model.dart';
import 'package:apprem_v1/Data/models/remission_model.dart';
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/remission_repository.dart';

class RemissionRepositoryImpl implements RemissionRepository {
  final RemissionLocalDataSource _localDataSource;
  RemissionRepositoryImpl(this._localDataSource);

  @override
  Future<List<Remission>> obtenerHistorialDeRemisiones() async{
    final modelos = await _localDataSource.obtenerHistorialRemisiones();
    return modelos;
  }
  @override
  Future<String> obtenerSiguienteFolio() async{
    //va por el numero que da la DB
    final nextNum = await _localDataSource.obtenerSiguienteFolio();
    /// Convierte el int a un String con ceros a la izquierda
    /// El .padLeft(4, '0') transforma un 5 en "0005", un 12 en "0012", etc.
    final formatedfolio = "REM-${nextNum.toString().padLeft(4,'0')}";
    //Devuelve un String.
    return formatedfolio;
  }

  @override
  Future<void> crearRemision(Remission remission) async{
    final remissionModel = RemissionModel.fromEntity(remission);
  //El modelo completo es el que se le manda al DataSource
  await _localDataSource.guardarRemision(remissionModel);
  }
  @override
  Future<Remission?> obtenerRemisionById(String id) async{
    final model = await _localDataSource.getRemissionById(id);
    return model;
  }

}