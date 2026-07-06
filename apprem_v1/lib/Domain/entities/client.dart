class Client {
  final String id;
  final String nombre;
  final String ubicacionCliente;

  const Client({
    required this.id,
    required this.nombre,
    required this.ubicacionCliente,
  });

  Client copyWith({
    String? id,
    String? nombre,
    String? ubicacionCliente,
  }) {
    return Client(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      ubicacionCliente: ubicacionCliente ?? this.ubicacionCliente,
    );
  }
}