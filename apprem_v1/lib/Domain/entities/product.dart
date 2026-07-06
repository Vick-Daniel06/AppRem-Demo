class Product
{
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

  Product copyWith({
    String? id,
    String? nombre,
    double? pesoKg,
    double? precioSugerido,
  }){
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      pesoKg:pesoKg ?? this.pesoKg,
      precioSugerido: precioSugerido ?? this.precioSugerido,
    );
  }
}