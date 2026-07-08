// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoKgMeta = const VerificationMeta('pesoKg');
  @override
  late final GeneratedColumn<double> pesoKg = GeneratedColumn<double>(
    'peso_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioSugeridoMeta = const VerificationMeta(
    'precioSugerido',
  );
  @override
  late final GeneratedColumn<double> precioSugerido = GeneratedColumn<double>(
    'precio_sugerido',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, pesoKg, precioSugerido];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('peso_kg')) {
      context.handle(
        _pesoKgMeta,
        pesoKg.isAcceptableOrUnknown(data['peso_kg']!, _pesoKgMeta),
      );
    } else if (isInserting) {
      context.missing(_pesoKgMeta);
    }
    if (data.containsKey('precio_sugerido')) {
      context.handle(
        _precioSugeridoMeta,
        precioSugerido.isAcceptableOrUnknown(
          data['precio_sugerido']!,
          _precioSugeridoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioSugeridoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      pesoKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_kg'],
      )!,
      precioSugerido: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_sugerido'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String nombre;
  final double pesoKg;
  final double precioSugerido;
  const Product({
    required this.id,
    required this.nombre,
    required this.pesoKg,
    required this.precioSugerido,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['peso_kg'] = Variable<double>(pesoKg);
    map['precio_sugerido'] = Variable<double>(precioSugerido);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      pesoKg: Value(pesoKg),
      precioSugerido: Value(precioSugerido),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      pesoKg: serializer.fromJson<double>(json['pesoKg']),
      precioSugerido: serializer.fromJson<double>(json['precioSugerido']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'pesoKg': serializer.toJson<double>(pesoKg),
      'precioSugerido': serializer.toJson<double>(precioSugerido),
    };
  }

  Product copyWith({
    String? id,
    String? nombre,
    double? pesoKg,
    double? precioSugerido,
  }) => Product(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    pesoKg: pesoKg ?? this.pesoKg,
    precioSugerido: precioSugerido ?? this.precioSugerido,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      pesoKg: data.pesoKg.present ? data.pesoKg.value : this.pesoKg,
      precioSugerido: data.precioSugerido.present
          ? data.precioSugerido.value
          : this.precioSugerido,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('pesoKg: $pesoKg, ')
          ..write('precioSugerido: $precioSugerido')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, pesoKg, precioSugerido);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.pesoKg == this.pesoKg &&
          other.precioSugerido == this.precioSugerido);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<double> pesoKg;
  final Value<double> precioSugerido;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.pesoKg = const Value.absent(),
    this.precioSugerido = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String nombre,
    required double pesoKg,
    required double precioSugerido,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       pesoKg = Value(pesoKg),
       precioSugerido = Value(precioSugerido);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<double>? pesoKg,
    Expression<double>? precioSugerido,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (pesoKg != null) 'peso_kg': pesoKg,
      if (precioSugerido != null) 'precio_sugerido': precioSugerido,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<double>? pesoKg,
    Value<double>? precioSugerido,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      pesoKg: pesoKg ?? this.pesoKg,
      precioSugerido: precioSugerido ?? this.precioSugerido,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (pesoKg.present) {
      map['peso_kg'] = Variable<double>(pesoKg.value);
    }
    if (precioSugerido.present) {
      map['precio_sugerido'] = Variable<double>(precioSugerido.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('pesoKg: $pesoKg, ')
          ..write('precioSugerido: $precioSugerido, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ubicacionClienteMeta = const VerificationMeta(
    'ubicacionCliente',
  );
  @override
  late final GeneratedColumn<String> ubicacionCliente = GeneratedColumn<String>(
    'ubicacion_cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, ubicacionCliente];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('ubicacion_cliente')) {
      context.handle(
        _ubicacionClienteMeta,
        ubicacionCliente.isAcceptableOrUnknown(
          data['ubicacion_cliente']!,
          _ubicacionClienteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ubicacionClienteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      ubicacionCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubicacion_cliente'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final String id;
  final String nombre;
  final String ubicacionCliente;
  const Client({
    required this.id,
    required this.nombre,
    required this.ubicacionCliente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['ubicacion_cliente'] = Variable<String>(ubicacionCliente);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      ubicacionCliente: Value(ubicacionCliente),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      ubicacionCliente: serializer.fromJson<String>(json['ubicacionCliente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'ubicacionCliente': serializer.toJson<String>(ubicacionCliente),
    };
  }

  Client copyWith({String? id, String? nombre, String? ubicacionCliente}) =>
      Client(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        ubicacionCliente: ubicacionCliente ?? this.ubicacionCliente,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      ubicacionCliente: data.ubicacionCliente.present
          ? data.ubicacionCliente.value
          : this.ubicacionCliente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ubicacionCliente: $ubicacionCliente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, ubicacionCliente);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.ubicacionCliente == this.ubicacionCliente);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> ubicacionCliente;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.ubicacionCliente = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String nombre,
    required String ubicacionCliente,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       ubicacionCliente = Value(ubicacionCliente);
  static Insertable<Client> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? ubicacionCliente,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (ubicacionCliente != null) 'ubicacion_cliente': ubicacionCliente,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? ubicacionCliente,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      ubicacionCliente: ubicacionCliente ?? this.ubicacionCliente,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (ubicacionCliente.present) {
      map['ubicacion_cliente'] = Variable<String>(ubicacionCliente.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ubicacionCliente: $ubicacionCliente, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemissionsTable extends Remissions
    with TableInfo<$RemissionsTable, Remission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  @override
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _nombreVendedorMeta = const VerificationMeta(
    'nombreVendedor',
  );
  @override
  late final GeneratedColumn<String> nombreVendedor = GeneratedColumn<String>(
    'nombre_vendedor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreClienteMeta = const VerificationMeta(
    'nombreCliente',
  );
  @override
  late final GeneratedColumn<String> nombreCliente = GeneratedColumn<String>(
    'nombre_cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firmaPathMeta = const VerificationMeta(
    'firmaPath',
  );
  @override
  late final GeneratedColumn<String> firmaPath = GeneratedColumn<String>(
    'firma_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fotoEvidenciaPathMeta = const VerificationMeta(
    'fotoEvidenciaPath',
  );
  @override
  late final GeneratedColumn<String> fotoEvidenciaPath =
      GeneratedColumn<String>(
        'foto_evidencia_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folio,
    fechaCreacion,
    nombreVendedor,
    nombreCliente,
    firmaPath,
    fotoEvidenciaPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Remission> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('nombre_vendedor')) {
      context.handle(
        _nombreVendedorMeta,
        nombreVendedor.isAcceptableOrUnknown(
          data['nombre_vendedor']!,
          _nombreVendedorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreVendedorMeta);
    }
    if (data.containsKey('nombre_cliente')) {
      context.handle(
        _nombreClienteMeta,
        nombreCliente.isAcceptableOrUnknown(
          data['nombre_cliente']!,
          _nombreClienteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreClienteMeta);
    }
    if (data.containsKey('firma_path')) {
      context.handle(
        _firmaPathMeta,
        firmaPath.isAcceptableOrUnknown(data['firma_path']!, _firmaPathMeta),
      );
    } else if (isInserting) {
      context.missing(_firmaPathMeta);
    }
    if (data.containsKey('foto_evidencia_path')) {
      context.handle(
        _fotoEvidenciaPathMeta,
        fotoEvidenciaPath.isAcceptableOrUnknown(
          data['foto_evidencia_path']!,
          _fotoEvidenciaPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Remission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Remission(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      nombreVendedor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_vendedor'],
      )!,
      nombreCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_cliente'],
      )!,
      firmaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firma_path'],
      )!,
      fotoEvidenciaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_evidencia_path'],
      ),
    );
  }

  @override
  $RemissionsTable createAlias(String alias) {
    return $RemissionsTable(attachedDatabase, alias);
  }
}

class Remission extends DataClass implements Insertable<Remission> {
  final String id;
  final String folio;
  final DateTime fechaCreacion;
  final String nombreVendedor;
  final String nombreCliente;
  final String firmaPath;
  final String? fotoEvidenciaPath;
  const Remission({
    required this.id,
    required this.folio,
    required this.fechaCreacion,
    required this.nombreVendedor,
    required this.nombreCliente,
    required this.firmaPath,
    this.fotoEvidenciaPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folio'] = Variable<String>(folio);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['nombre_vendedor'] = Variable<String>(nombreVendedor);
    map['nombre_cliente'] = Variable<String>(nombreCliente);
    map['firma_path'] = Variable<String>(firmaPath);
    if (!nullToAbsent || fotoEvidenciaPath != null) {
      map['foto_evidencia_path'] = Variable<String>(fotoEvidenciaPath);
    }
    return map;
  }

  RemissionsCompanion toCompanion(bool nullToAbsent) {
    return RemissionsCompanion(
      id: Value(id),
      folio: Value(folio),
      fechaCreacion: Value(fechaCreacion),
      nombreVendedor: Value(nombreVendedor),
      nombreCliente: Value(nombreCliente),
      firmaPath: Value(firmaPath),
      fotoEvidenciaPath: fotoEvidenciaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoEvidenciaPath),
    );
  }

  factory Remission.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Remission(
      id: serializer.fromJson<String>(json['id']),
      folio: serializer.fromJson<String>(json['folio']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      nombreVendedor: serializer.fromJson<String>(json['nombreVendedor']),
      nombreCliente: serializer.fromJson<String>(json['nombreCliente']),
      firmaPath: serializer.fromJson<String>(json['firmaPath']),
      fotoEvidenciaPath: serializer.fromJson<String?>(
        json['fotoEvidenciaPath'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folio': serializer.toJson<String>(folio),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'nombreVendedor': serializer.toJson<String>(nombreVendedor),
      'nombreCliente': serializer.toJson<String>(nombreCliente),
      'firmaPath': serializer.toJson<String>(firmaPath),
      'fotoEvidenciaPath': serializer.toJson<String?>(fotoEvidenciaPath),
    };
  }

  Remission copyWith({
    String? id,
    String? folio,
    DateTime? fechaCreacion,
    String? nombreVendedor,
    String? nombreCliente,
    String? firmaPath,
    Value<String?> fotoEvidenciaPath = const Value.absent(),
  }) => Remission(
    id: id ?? this.id,
    folio: folio ?? this.folio,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    nombreVendedor: nombreVendedor ?? this.nombreVendedor,
    nombreCliente: nombreCliente ?? this.nombreCliente,
    firmaPath: firmaPath ?? this.firmaPath,
    fotoEvidenciaPath: fotoEvidenciaPath.present
        ? fotoEvidenciaPath.value
        : this.fotoEvidenciaPath,
  );
  Remission copyWithCompanion(RemissionsCompanion data) {
    return Remission(
      id: data.id.present ? data.id.value : this.id,
      folio: data.folio.present ? data.folio.value : this.folio,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      nombreVendedor: data.nombreVendedor.present
          ? data.nombreVendedor.value
          : this.nombreVendedor,
      nombreCliente: data.nombreCliente.present
          ? data.nombreCliente.value
          : this.nombreCliente,
      firmaPath: data.firmaPath.present ? data.firmaPath.value : this.firmaPath,
      fotoEvidenciaPath: data.fotoEvidenciaPath.present
          ? data.fotoEvidenciaPath.value
          : this.fotoEvidenciaPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Remission(')
          ..write('id: $id, ')
          ..write('folio: $folio, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('nombreVendedor: $nombreVendedor, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('firmaPath: $firmaPath, ')
          ..write('fotoEvidenciaPath: $fotoEvidenciaPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folio,
    fechaCreacion,
    nombreVendedor,
    nombreCliente,
    firmaPath,
    fotoEvidenciaPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Remission &&
          other.id == this.id &&
          other.folio == this.folio &&
          other.fechaCreacion == this.fechaCreacion &&
          other.nombreVendedor == this.nombreVendedor &&
          other.nombreCliente == this.nombreCliente &&
          other.firmaPath == this.firmaPath &&
          other.fotoEvidenciaPath == this.fotoEvidenciaPath);
}

class RemissionsCompanion extends UpdateCompanion<Remission> {
  final Value<String> id;
  final Value<String> folio;
  final Value<DateTime> fechaCreacion;
  final Value<String> nombreVendedor;
  final Value<String> nombreCliente;
  final Value<String> firmaPath;
  final Value<String?> fotoEvidenciaPath;
  final Value<int> rowid;
  const RemissionsCompanion({
    this.id = const Value.absent(),
    this.folio = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.nombreVendedor = const Value.absent(),
    this.nombreCliente = const Value.absent(),
    this.firmaPath = const Value.absent(),
    this.fotoEvidenciaPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemissionsCompanion.insert({
    required String id,
    required String folio,
    required DateTime fechaCreacion,
    required String nombreVendedor,
    required String nombreCliente,
    required String firmaPath,
    this.fotoEvidenciaPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folio = Value(folio),
       fechaCreacion = Value(fechaCreacion),
       nombreVendedor = Value(nombreVendedor),
       nombreCliente = Value(nombreCliente),
       firmaPath = Value(firmaPath);
  static Insertable<Remission> custom({
    Expression<String>? id,
    Expression<String>? folio,
    Expression<DateTime>? fechaCreacion,
    Expression<String>? nombreVendedor,
    Expression<String>? nombreCliente,
    Expression<String>? firmaPath,
    Expression<String>? fotoEvidenciaPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folio != null) 'folio': folio,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (nombreVendedor != null) 'nombre_vendedor': nombreVendedor,
      if (nombreCliente != null) 'nombre_cliente': nombreCliente,
      if (firmaPath != null) 'firma_path': firmaPath,
      if (fotoEvidenciaPath != null) 'foto_evidencia_path': fotoEvidenciaPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemissionsCompanion copyWith({
    Value<String>? id,
    Value<String>? folio,
    Value<DateTime>? fechaCreacion,
    Value<String>? nombreVendedor,
    Value<String>? nombreCliente,
    Value<String>? firmaPath,
    Value<String?>? fotoEvidenciaPath,
    Value<int>? rowid,
  }) {
    return RemissionsCompanion(
      id: id ?? this.id,
      folio: folio ?? this.folio,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      nombreVendedor: nombreVendedor ?? this.nombreVendedor,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      firmaPath: firmaPath ?? this.firmaPath,
      fotoEvidenciaPath: fotoEvidenciaPath ?? this.fotoEvidenciaPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (nombreVendedor.present) {
      map['nombre_vendedor'] = Variable<String>(nombreVendedor.value);
    }
    if (nombreCliente.present) {
      map['nombre_cliente'] = Variable<String>(nombreCliente.value);
    }
    if (firmaPath.present) {
      map['firma_path'] = Variable<String>(firmaPath.value);
    }
    if (fotoEvidenciaPath.present) {
      map['foto_evidencia_path'] = Variable<String>(fotoEvidenciaPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemissionsCompanion(')
          ..write('id: $id, ')
          ..write('folio: $folio, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('nombreVendedor: $nombreVendedor, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('firmaPath: $firmaPath, ')
          ..write('fotoEvidenciaPath: $fotoEvidenciaPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DetailLinesTable extends DetailLines
    with TableInfo<$DetailLinesTable, DetailLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetailLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remisionIdMeta = const VerificationMeta(
    'remisionId',
  );
  @override
  late final GeneratedColumn<String> remisionId = GeneratedColumn<String>(
    'remision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES remissions(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreProductoMeta = const VerificationMeta(
    'nombreProducto',
  );
  @override
  late final GeneratedColumn<String> nombreProducto = GeneratedColumn<String>(
    'nombre_producto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioSugeridoOriginalMeta =
      const VerificationMeta('precioSugeridoOriginal');
  @override
  late final GeneratedColumn<double> precioSugeridoOriginal =
      GeneratedColumn<double>(
        'precio_sugerido_original',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _precioUnitarioEnEseMomentoMeta =
      const VerificationMeta('precioUnitarioEnEseMomento');
  @override
  late final GeneratedColumn<double> precioUnitarioEnEseMomento =
      GeneratedColumn<double>(
        'precio_unitario_en_ese_momento',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remisionId,
    productoId,
    nombreProducto,
    cantidad,
    precioSugeridoOriginal,
    precioUnitarioEnEseMomento,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detail_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<DetailLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('remision_id')) {
      context.handle(
        _remisionIdMeta,
        remisionId.isAcceptableOrUnknown(data['remision_id']!, _remisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remisionIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('nombre_producto')) {
      context.handle(
        _nombreProductoMeta,
        nombreProducto.isAcceptableOrUnknown(
          data['nombre_producto']!,
          _nombreProductoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreProductoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_sugerido_original')) {
      context.handle(
        _precioSugeridoOriginalMeta,
        precioSugeridoOriginal.isAcceptableOrUnknown(
          data['precio_sugerido_original']!,
          _precioSugeridoOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioSugeridoOriginalMeta);
    }
    if (data.containsKey('precio_unitario_en_ese_momento')) {
      context.handle(
        _precioUnitarioEnEseMomentoMeta,
        precioUnitarioEnEseMomento.isAcceptableOrUnknown(
          data['precio_unitario_en_ese_momento']!,
          _precioUnitarioEnEseMomentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioEnEseMomentoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DetailLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetailLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      remisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remision_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      )!,
      nombreProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_producto'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioSugeridoOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_sugerido_original'],
      )!,
      precioUnitarioEnEseMomento: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario_en_ese_momento'],
      )!,
    );
  }

  @override
  $DetailLinesTable createAlias(String alias) {
    return $DetailLinesTable(attachedDatabase, alias);
  }
}

class DetailLine extends DataClass implements Insertable<DetailLine> {
  final String id;
  final String remisionId;
  final String productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioSugeridoOriginal;
  final double precioUnitarioEnEseMomento;
  const DetailLine({
    required this.id,
    required this.remisionId,
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioSugeridoOriginal,
    required this.precioUnitarioEnEseMomento,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['remision_id'] = Variable<String>(remisionId);
    map['producto_id'] = Variable<String>(productoId);
    map['nombre_producto'] = Variable<String>(nombreProducto);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_sugerido_original'] = Variable<double>(precioSugeridoOriginal);
    map['precio_unitario_en_ese_momento'] = Variable<double>(
      precioUnitarioEnEseMomento,
    );
    return map;
  }

  DetailLinesCompanion toCompanion(bool nullToAbsent) {
    return DetailLinesCompanion(
      id: Value(id),
      remisionId: Value(remisionId),
      productoId: Value(productoId),
      nombreProducto: Value(nombreProducto),
      cantidad: Value(cantidad),
      precioSugeridoOriginal: Value(precioSugeridoOriginal),
      precioUnitarioEnEseMomento: Value(precioUnitarioEnEseMomento),
    );
  }

  factory DetailLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetailLine(
      id: serializer.fromJson<String>(json['id']),
      remisionId: serializer.fromJson<String>(json['remisionId']),
      productoId: serializer.fromJson<String>(json['productoId']),
      nombreProducto: serializer.fromJson<String>(json['nombreProducto']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioSugeridoOriginal: serializer.fromJson<double>(
        json['precioSugeridoOriginal'],
      ),
      precioUnitarioEnEseMomento: serializer.fromJson<double>(
        json['precioUnitarioEnEseMomento'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'remisionId': serializer.toJson<String>(remisionId),
      'productoId': serializer.toJson<String>(productoId),
      'nombreProducto': serializer.toJson<String>(nombreProducto),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioSugeridoOriginal': serializer.toJson<double>(
        precioSugeridoOriginal,
      ),
      'precioUnitarioEnEseMomento': serializer.toJson<double>(
        precioUnitarioEnEseMomento,
      ),
    };
  }

  DetailLine copyWith({
    String? id,
    String? remisionId,
    String? productoId,
    String? nombreProducto,
    int? cantidad,
    double? precioSugeridoOriginal,
    double? precioUnitarioEnEseMomento,
  }) => DetailLine(
    id: id ?? this.id,
    remisionId: remisionId ?? this.remisionId,
    productoId: productoId ?? this.productoId,
    nombreProducto: nombreProducto ?? this.nombreProducto,
    cantidad: cantidad ?? this.cantidad,
    precioSugeridoOriginal:
        precioSugeridoOriginal ?? this.precioSugeridoOriginal,
    precioUnitarioEnEseMomento:
        precioUnitarioEnEseMomento ?? this.precioUnitarioEnEseMomento,
  );
  DetailLine copyWithCompanion(DetailLinesCompanion data) {
    return DetailLine(
      id: data.id.present ? data.id.value : this.id,
      remisionId: data.remisionId.present
          ? data.remisionId.value
          : this.remisionId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      nombreProducto: data.nombreProducto.present
          ? data.nombreProducto.value
          : this.nombreProducto,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioSugeridoOriginal: data.precioSugeridoOriginal.present
          ? data.precioSugeridoOriginal.value
          : this.precioSugeridoOriginal,
      precioUnitarioEnEseMomento: data.precioUnitarioEnEseMomento.present
          ? data.precioUnitarioEnEseMomento.value
          : this.precioUnitarioEnEseMomento,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetailLine(')
          ..write('id: $id, ')
          ..write('remisionId: $remisionId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioSugeridoOriginal: $precioSugeridoOriginal, ')
          ..write('precioUnitarioEnEseMomento: $precioUnitarioEnEseMomento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remisionId,
    productoId,
    nombreProducto,
    cantidad,
    precioSugeridoOriginal,
    precioUnitarioEnEseMomento,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetailLine &&
          other.id == this.id &&
          other.remisionId == this.remisionId &&
          other.productoId == this.productoId &&
          other.nombreProducto == this.nombreProducto &&
          other.cantidad == this.cantidad &&
          other.precioSugeridoOriginal == this.precioSugeridoOriginal &&
          other.precioUnitarioEnEseMomento == this.precioUnitarioEnEseMomento);
}

class DetailLinesCompanion extends UpdateCompanion<DetailLine> {
  final Value<String> id;
  final Value<String> remisionId;
  final Value<String> productoId;
  final Value<String> nombreProducto;
  final Value<int> cantidad;
  final Value<double> precioSugeridoOriginal;
  final Value<double> precioUnitarioEnEseMomento;
  final Value<int> rowid;
  const DetailLinesCompanion({
    this.id = const Value.absent(),
    this.remisionId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.nombreProducto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioSugeridoOriginal = const Value.absent(),
    this.precioUnitarioEnEseMomento = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DetailLinesCompanion.insert({
    required String id,
    required String remisionId,
    required String productoId,
    required String nombreProducto,
    required int cantidad,
    required double precioSugeridoOriginal,
    required double precioUnitarioEnEseMomento,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       remisionId = Value(remisionId),
       productoId = Value(productoId),
       nombreProducto = Value(nombreProducto),
       cantidad = Value(cantidad),
       precioSugeridoOriginal = Value(precioSugeridoOriginal),
       precioUnitarioEnEseMomento = Value(precioUnitarioEnEseMomento);
  static Insertable<DetailLine> custom({
    Expression<String>? id,
    Expression<String>? remisionId,
    Expression<String>? productoId,
    Expression<String>? nombreProducto,
    Expression<int>? cantidad,
    Expression<double>? precioSugeridoOriginal,
    Expression<double>? precioUnitarioEnEseMomento,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remisionId != null) 'remision_id': remisionId,
      if (productoId != null) 'producto_id': productoId,
      if (nombreProducto != null) 'nombre_producto': nombreProducto,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioSugeridoOriginal != null)
        'precio_sugerido_original': precioSugeridoOriginal,
      if (precioUnitarioEnEseMomento != null)
        'precio_unitario_en_ese_momento': precioUnitarioEnEseMomento,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DetailLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? remisionId,
    Value<String>? productoId,
    Value<String>? nombreProducto,
    Value<int>? cantidad,
    Value<double>? precioSugeridoOriginal,
    Value<double>? precioUnitarioEnEseMomento,
    Value<int>? rowid,
  }) {
    return DetailLinesCompanion(
      id: id ?? this.id,
      remisionId: remisionId ?? this.remisionId,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      cantidad: cantidad ?? this.cantidad,
      precioSugeridoOriginal:
          precioSugeridoOriginal ?? this.precioSugeridoOriginal,
      precioUnitarioEnEseMomento:
          precioUnitarioEnEseMomento ?? this.precioUnitarioEnEseMomento,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (remisionId.present) {
      map['remision_id'] = Variable<String>(remisionId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (nombreProducto.present) {
      map['nombre_producto'] = Variable<String>(nombreProducto.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioSugeridoOriginal.present) {
      map['precio_sugerido_original'] = Variable<double>(
        precioSugeridoOriginal.value,
      );
    }
    if (precioUnitarioEnEseMomento.present) {
      map['precio_unitario_en_ese_momento'] = Variable<double>(
        precioUnitarioEnEseMomento.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetailLinesCompanion(')
          ..write('id: $id, ')
          ..write('remisionId: $remisionId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioSugeridoOriginal: $precioSugeridoOriginal, ')
          ..write('precioUnitarioEnEseMomento: $precioUnitarioEnEseMomento, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $RemissionsTable remissions = $RemissionsTable(this);
  late final $DetailLinesTable detailLines = $DetailLinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    clients,
    remissions,
    detailLines,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'remissions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('detail_lines', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String nombre,
      required double pesoKg,
      required double precioSugerido,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<double> pesoKg,
      Value<double> precioSugerido,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoKg => $composableBuilder(
    column: $table.pesoKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioSugerido => $composableBuilder(
    column: $table.precioSugerido,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoKg => $composableBuilder(
    column: $table.pesoKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioSugerido => $composableBuilder(
    column: $table.precioSugerido,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get pesoKg =>
      $composableBuilder(column: $table.pesoKg, builder: (column) => column);

  GeneratedColumn<double> get precioSugerido => $composableBuilder(
    column: $table.precioSugerido,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> pesoKg = const Value.absent(),
                Value<double> precioSugerido = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                nombre: nombre,
                pesoKg: pesoKg,
                precioSugerido: precioSugerido,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required double pesoKg,
                required double precioSugerido,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                nombre: nombre,
                pesoKg: pesoKg,
                precioSugerido: precioSugerido,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      required String id,
      required String nombre,
      required String ubicacionCliente,
      Value<int> rowid,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> ubicacionCliente,
      Value<int> rowid,
    });

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubicacionCliente => $composableBuilder(
    column: $table.ubicacionCliente,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubicacionCliente => $composableBuilder(
    column: $table.ubicacionCliente,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get ubicacionCliente => $composableBuilder(
    column: $table.ubicacionCliente,
    builder: (column) => column,
  );
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
          Client,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> ubicacionCliente = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                nombre: nombre,
                ubicacionCliente: ubicacionCliente,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String ubicacionCliente,
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                nombre: nombre,
                ubicacionCliente: ubicacionCliente,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
      Client,
      PrefetchHooks Function()
    >;
typedef $$RemissionsTableCreateCompanionBuilder =
    RemissionsCompanion Function({
      required String id,
      required String folio,
      required DateTime fechaCreacion,
      required String nombreVendedor,
      required String nombreCliente,
      required String firmaPath,
      Value<String?> fotoEvidenciaPath,
      Value<int> rowid,
    });
typedef $$RemissionsTableUpdateCompanionBuilder =
    RemissionsCompanion Function({
      Value<String> id,
      Value<String> folio,
      Value<DateTime> fechaCreacion,
      Value<String> nombreVendedor,
      Value<String> nombreCliente,
      Value<String> firmaPath,
      Value<String?> fotoEvidenciaPath,
      Value<int> rowid,
    });

final class $$RemissionsTableReferences
    extends BaseReferences<_$AppDatabase, $RemissionsTable, Remission> {
  $$RemissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DetailLinesTable, List<DetailLine>>
  _detailLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.detailLines,
    aliasName: 'remissions__id__detail_lines__remision_id',
  );

  $$DetailLinesTableProcessedTableManager get detailLinesRefs {
    final manager = $$DetailLinesTableTableManager(
      $_db,
      $_db.detailLines,
    ).filter((f) => f.remisionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_detailLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemissionsTableFilterComposer
    extends Composer<_$AppDatabase, $RemissionsTable> {
  $$RemissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreVendedor => $composableBuilder(
    column: $table.nombreVendedor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firmaPath => $composableBuilder(
    column: $table.firmaPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoEvidenciaPath => $composableBuilder(
    column: $table.fotoEvidenciaPath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> detailLinesRefs(
    Expression<bool> Function($$DetailLinesTableFilterComposer f) f,
  ) {
    final $$DetailLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detailLines,
      getReferencedColumn: (t) => t.remisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DetailLinesTableFilterComposer(
            $db: $db,
            $table: $db.detailLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RemissionsTable> {
  $$RemissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreVendedor => $composableBuilder(
    column: $table.nombreVendedor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firmaPath => $composableBuilder(
    column: $table.firmaPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoEvidenciaPath => $composableBuilder(
    column: $table.fotoEvidenciaPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemissionsTable> {
  $$RemissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreVendedor => $composableBuilder(
    column: $table.nombreVendedor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firmaPath =>
      $composableBuilder(column: $table.firmaPath, builder: (column) => column);

  GeneratedColumn<String> get fotoEvidenciaPath => $composableBuilder(
    column: $table.fotoEvidenciaPath,
    builder: (column) => column,
  );

  Expression<T> detailLinesRefs<T extends Object>(
    Expression<T> Function($$DetailLinesTableAnnotationComposer a) f,
  ) {
    final $$DetailLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detailLines,
      getReferencedColumn: (t) => t.remisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DetailLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.detailLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemissionsTable,
          Remission,
          $$RemissionsTableFilterComposer,
          $$RemissionsTableOrderingComposer,
          $$RemissionsTableAnnotationComposer,
          $$RemissionsTableCreateCompanionBuilder,
          $$RemissionsTableUpdateCompanionBuilder,
          (Remission, $$RemissionsTableReferences),
          Remission,
          PrefetchHooks Function({bool detailLinesRefs})
        > {
  $$RemissionsTableTableManager(_$AppDatabase db, $RemissionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<String> nombreVendedor = const Value.absent(),
                Value<String> nombreCliente = const Value.absent(),
                Value<String> firmaPath = const Value.absent(),
                Value<String?> fotoEvidenciaPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemissionsCompanion(
                id: id,
                folio: folio,
                fechaCreacion: fechaCreacion,
                nombreVendedor: nombreVendedor,
                nombreCliente: nombreCliente,
                firmaPath: firmaPath,
                fotoEvidenciaPath: fotoEvidenciaPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folio,
                required DateTime fechaCreacion,
                required String nombreVendedor,
                required String nombreCliente,
                required String firmaPath,
                Value<String?> fotoEvidenciaPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemissionsCompanion.insert(
                id: id,
                folio: folio,
                fechaCreacion: fechaCreacion,
                nombreVendedor: nombreVendedor,
                nombreCliente: nombreCliente,
                firmaPath: firmaPath,
                fotoEvidenciaPath: fotoEvidenciaPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemissionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({detailLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (detailLinesRefs) db.detailLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (detailLinesRefs)
                    await $_getPrefetchedData<
                      Remission,
                      $RemissionsTable,
                      DetailLine
                    >(
                      currentTable: table,
                      referencedTable: $$RemissionsTableReferences
                          ._detailLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RemissionsTableReferences(
                            db,
                            table,
                            p0,
                          ).detailLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.remisionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RemissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemissionsTable,
      Remission,
      $$RemissionsTableFilterComposer,
      $$RemissionsTableOrderingComposer,
      $$RemissionsTableAnnotationComposer,
      $$RemissionsTableCreateCompanionBuilder,
      $$RemissionsTableUpdateCompanionBuilder,
      (Remission, $$RemissionsTableReferences),
      Remission,
      PrefetchHooks Function({bool detailLinesRefs})
    >;
typedef $$DetailLinesTableCreateCompanionBuilder =
    DetailLinesCompanion Function({
      required String id,
      required String remisionId,
      required String productoId,
      required String nombreProducto,
      required int cantidad,
      required double precioSugeridoOriginal,
      required double precioUnitarioEnEseMomento,
      Value<int> rowid,
    });
typedef $$DetailLinesTableUpdateCompanionBuilder =
    DetailLinesCompanion Function({
      Value<String> id,
      Value<String> remisionId,
      Value<String> productoId,
      Value<String> nombreProducto,
      Value<int> cantidad,
      Value<double> precioSugeridoOriginal,
      Value<double> precioUnitarioEnEseMomento,
      Value<int> rowid,
    });

final class $$DetailLinesTableReferences
    extends BaseReferences<_$AppDatabase, $DetailLinesTable, DetailLine> {
  $$DetailLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RemissionsTable _remisionIdTable(_$AppDatabase db) =>
      db.remissions.createAlias('detail_lines__remision_id__remissions__id');

  $$RemissionsTableProcessedTableManager get remisionId {
    final $_column = $_itemColumn<String>('remision_id')!;

    final manager = $$RemissionsTableTableManager(
      $_db,
      $_db.remissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_remisionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DetailLinesTableFilterComposer
    extends Composer<_$AppDatabase, $DetailLinesTable> {
  $$DetailLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioSugeridoOriginal => $composableBuilder(
    column: $table.precioSugeridoOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitarioEnEseMomento => $composableBuilder(
    column: $table.precioUnitarioEnEseMomento,
    builder: (column) => ColumnFilters(column),
  );

  $$RemissionsTableFilterComposer get remisionId {
    final $$RemissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remisionId,
      referencedTable: $db.remissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemissionsTableFilterComposer(
            $db: $db,
            $table: $db.remissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DetailLinesTable> {
  $$DetailLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioSugeridoOriginal => $composableBuilder(
    column: $table.precioSugeridoOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitarioEnEseMomento => $composableBuilder(
    column: $table.precioUnitarioEnEseMomento,
    builder: (column) => ColumnOrderings(column),
  );

  $$RemissionsTableOrderingComposer get remisionId {
    final $$RemissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remisionId,
      referencedTable: $db.remissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemissionsTableOrderingComposer(
            $db: $db,
            $table: $db.remissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetailLinesTable> {
  $$DetailLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioSugeridoOriginal => $composableBuilder(
    column: $table.precioSugeridoOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioUnitarioEnEseMomento => $composableBuilder(
    column: $table.precioUnitarioEnEseMomento,
    builder: (column) => column,
  );

  $$RemissionsTableAnnotationComposer get remisionId {
    final $$RemissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remisionId,
      referencedTable: $db.remissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.remissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DetailLinesTable,
          DetailLine,
          $$DetailLinesTableFilterComposer,
          $$DetailLinesTableOrderingComposer,
          $$DetailLinesTableAnnotationComposer,
          $$DetailLinesTableCreateCompanionBuilder,
          $$DetailLinesTableUpdateCompanionBuilder,
          (DetailLine, $$DetailLinesTableReferences),
          DetailLine,
          PrefetchHooks Function({bool remisionId})
        > {
  $$DetailLinesTableTableManager(_$AppDatabase db, $DetailLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetailLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DetailLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetailLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> remisionId = const Value.absent(),
                Value<String> productoId = const Value.absent(),
                Value<String> nombreProducto = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioSugeridoOriginal = const Value.absent(),
                Value<double> precioUnitarioEnEseMomento = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DetailLinesCompanion(
                id: id,
                remisionId: remisionId,
                productoId: productoId,
                nombreProducto: nombreProducto,
                cantidad: cantidad,
                precioSugeridoOriginal: precioSugeridoOriginal,
                precioUnitarioEnEseMomento: precioUnitarioEnEseMomento,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String remisionId,
                required String productoId,
                required String nombreProducto,
                required int cantidad,
                required double precioSugeridoOriginal,
                required double precioUnitarioEnEseMomento,
                Value<int> rowid = const Value.absent(),
              }) => DetailLinesCompanion.insert(
                id: id,
                remisionId: remisionId,
                productoId: productoId,
                nombreProducto: nombreProducto,
                cantidad: cantidad,
                precioSugeridoOriginal: precioSugeridoOriginal,
                precioUnitarioEnEseMomento: precioUnitarioEnEseMomento,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DetailLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({remisionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (remisionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.remisionId,
                                referencedTable: $$DetailLinesTableReferences
                                    ._remisionIdTable(db),
                                referencedColumn: $$DetailLinesTableReferences
                                    ._remisionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DetailLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DetailLinesTable,
      DetailLine,
      $$DetailLinesTableFilterComposer,
      $$DetailLinesTableOrderingComposer,
      $$DetailLinesTableAnnotationComposer,
      $$DetailLinesTableCreateCompanionBuilder,
      $$DetailLinesTableUpdateCompanionBuilder,
      (DetailLine, $$DetailLinesTableReferences),
      DetailLine,
      PrefetchHooks Function({bool remisionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$RemissionsTableTableManager get remissions =>
      $$RemissionsTableTableManager(_db, _db.remissions);
  $$DetailLinesTableTableManager get detailLines =>
      $$DetailLinesTableTableManager(_db, _db.detailLines);
}
