
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // 1. Primero creamos físicamente todas las tablas en SQLite
        await m.createAll();

        // 2. Insertamos Clientes semilla (usando los Companions que genera Drift)
        // Nota: Si tus tablas se llaman "Products" o "Clients", Drift genera "ProductsCompanion"
        await into(clients).insert(ClientsCompanion.insert(
          id: 'client-uuid-1',
          nombre: 'Distribuidora Martínez',
          ubicacionCliente: 'Av. Constitución #450, Centro',
        ));

        await into(clients).insert(ClientsCompanion.insert(
          id: 'client-uuid-2',
          nombre: 'Abarrotes San Juan',
          ubicacionCliente: 'Calle Tercera #12, Industrial',
        ));

        // 3. Insertamos Productos semilla con precios base
        await into(products).insert(ProductsCompanion.insert(
          id: 'prod-uuid-1',
          nombre: 'Caja de Tomate Rojo',
          pesoKg: 25.0,
          precioSugerido: 350.0,
        ));

        await into(products).insert(ProductsCompanion.insert(
          id: 'prod-uuid-2',
          nombre: 'Saco de Papa Blanca',
          pesoKg: 50.0,
          precioSugerido: 600.0,
        ));

        await into(products).insert(ProductsCompanion.insert(
          id: 'prod-uuid-3',
          nombre: 'Arpilla de Cebolla',
          pesoKg: 30.0,
          precioSugerido: 420.0,
        ));
      },
    );
  }
}

/// Función interna para abrir la conexión al archivo físico .sqlite en el dispositivo
QueryExecutor _openConnection(){
  return driftDatabase(name: 'apprem');
  
}

