import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

//Tabla Productos
class Products extends Table{
  TextColumn get id => text()();// Llave primaria en texto (UUID)
  TextColumn get nombre => text()();
  RealColumn get pesoKg => real()();// Real equivale a Double en SQLite
  RealColumn get precioSugerido => real()();
  @override
  Set<Column> get primaryKey => {id};// Configuramos el ID como llave primaria
}
//Tabla clientes
class Clients extends Table{
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get ubicacionCliente => text()();

  @override
  Set<Column> get primaryKey => {id};
}
//Table de Remisiones, lleva la cabecera 
class Remissions extends Table{
  TextColumn get id => text()();
  TextColumn get folio => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  TextColumn get nombreVendedor => text()();
  TextColumn get nombreCliente => text()();
  TextColumn get firmaPath => text()();
  TextColumn get fotoEvidenciaPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
//Tabal Details Lines(los reglones de la remision)
class DetailLines extends Table{
  TextColumn get id => text()();
// Llave foránea que amarra el renglón a la remisión principal
  TextColumn get remisionId => text().customConstraint('NOT NULL REFERENCES remissions(id) ON DELETE CASCADE')();
  TextColumn get productoId => text()();
  TextColumn get nombreProducto => text()();
  IntColumn get cantidad => integer()();
  RealColumn get precioSugeridoOriginal => real()();
  RealColumn get precioUnitarioEnEseMomento => real()();
  @override
  Set<Column> get primaryKey => {id};
}


//Aquí registramos todas nuestras tablas
@DriftDatabase(tables: [Products, Clients, Remissions, DetailLines])
class AppDatabase extends _$AppDatabase {

  AppDatabase(): super(_openConnection());
// El control de versiones
  @override
  int get schemaVersion => 1;
}
/// Función interna para abrir la conexión al archivo físico .sqlite en el dispositivo
LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'apprem.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

