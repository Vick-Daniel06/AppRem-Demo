import 'package:get_it/get_it.dart';
import 'package:apprem_v1/Data/database/app_database.dart';

import 'package:apprem_v1/Domain/usecases/client/delete_client_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/get_clients_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/save_client_use_case.dart';
import 'package:apprem_v1/Domain/usecases/client/update_client_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/update_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/delete_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/save_product_use_case.dart';
import 'package:apprem_v1/Domain/usecases/product/get_products_use_case.dart';

import 'package:apprem_v1/Data/datasources/client_local_data_source.dart';
import 'package:apprem_v1/data/datasources/product_local_data_source.dart'; ///encuentra el archivo en data y no en Data como debe de ser
import 'package:apprem_v1/Data/datasources/remission_local_data_source.dart';

import 'Domain/respositories_interfaces/client_repository.dart';
import 'Data/respositories/client_repository_impl.dart';
import 'package:apprem_v1/Domain/respositories_interfaces/product_repository.dart';
import 'package:apprem_v1/Data/respositories/product_repository_impl.dart';
import 'Domain/respositories_interfaces/remission_repository.dart';
import 'Data/respositories/remission_repository_impl.dart';

final sl = GetIt.instance; //sl es la instancia global de Get

Future<void> init() async{
  //Registra una unica instancia de la base de datos a toda la app
  sl.registerSingleton<AppDatabase>(AppDatabase());
  /// Se inicializa solo cuando alguien los pide por primera vez
  /// Se inyecta la instancia AppDatabase que se regitra arriba en el sl
  sl.registerLazySingleton(()=> ProductLocalDataSource(sl<AppDatabase>()));
  sl.registerLazySingleton(()=> ClientLocalDataSource(sl<AppDatabase>()));
  sl.registerLazySingleton(()=> RemissionLocalDataSource(sl<AppDatabase>()));


//Se registra la interfaz del dominio y que GetIt devuelva la implementacion de la capa data
  sl.registerLazySingleton<ProductRepository>(
    ()=> ProductRepositoryImpl(sl<ProductLocalDataSource>()),
  );

  sl.registerLazySingleton<ClientRepository>(
    ()=> ClientRepositoryImpl(sl<ClientLocalDataSource>()),
  );

  sl.registerLazySingleton<RemissionRepository>(
    ()=> RemissionRepositoryImpl(sl<RemissionLocalDataSource>()),
  );
  //USE CASEs
  sl.registerLazySingleton(()=> GetProductsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(()=> SaveProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(()=> UpdateProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(()=> DeleteProductUseCase(sl<ProductRepository>()));

  sl.registerLazySingleton(()=> GetClientsUseCase(sl<ClientRepository>()));
  sl.registerLazySingleton(()=> SaveClientUseCase(sl<ClientRepository>()));
  sl.registerLazySingleton(()=> UpdateClientUseCase(sl<ClientRepository>()));
  sl.registerLazySingleton(()=> DeleteClientUseCase(sl<ClientRepository>()));
  
}


