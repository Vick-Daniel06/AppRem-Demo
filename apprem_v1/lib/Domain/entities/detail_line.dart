
class DetailLine {
  final String id;
  final String remisionId;
  final String prodctoId;
  final String nombreProducto;
  final int cantidad;
  final double precioSugeridoOriginal;//Precio actual 
  final double precioUnitarioEnEseMomento; //Precio del producto en esa Remision

  double get subtotal => cantidad * precioUnitarioEnEseMomento;

  const DetailLine({
    required this.id,
    required this.remisionId,
    required this.prodctoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioSugeridoOriginal,
    required this.precioUnitarioEnEseMomento,
    
  });
  DetailLine copyWith({
    String? id,
    String? remisionId,
    String? prodctoId,
    String?nombreProducto,
    int? cantidad,
    double? precioSugeridoOriginal,
    double? precioUnitarioEnEseMomento,

  }){
    return DetailLine(id: id ?? this.id,
     remisionId: remisionId ?? this.remisionId,
      prodctoId: prodctoId ?? this.prodctoId,
       nombreProducto: nombreProducto?? this.nombreProducto,
        cantidad: cantidad?? this.cantidad,
         precioSugeridoOriginal: precioSugeridoOriginal?? this.precioSugeridoOriginal,
          precioUnitarioEnEseMomento: precioUnitarioEnEseMomento?? this.precioUnitarioEnEseMomento
          );
  }

}