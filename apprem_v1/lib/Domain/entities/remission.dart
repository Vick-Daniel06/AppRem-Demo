import 'package:apprem_v1/Domain/entities/detail_line.dart';

class Remission {
  final String id;
  final String folio;
  final DateTime fechaCreacion;
  final String nombreVendedor;
  final String nombreCliente;
  final String firmaPath;
  final String? fotoEvidenciaPath;
  final List<DetailLine> detailLines;
//Getter para la suma total de las lineas, usando "fold"
  double get montoTotal => detailLines.fold(0.0, (sum, line) => sum + line.subtotal);

  const Remission({
    required this.id,
    required this.folio,
    required this.fechaCreacion,
    required this.nombreVendedor,
    required this.nombreCliente,
    required this.detailLines,
    required this.firmaPath,
    required this.fotoEvidenciaPath,
   
  });

  Remission copyWith({
    String? id,
    String? folio,
    DateTime? fechaCreacion,
    String? nombreVendedor,
    String? nombreCliente,
    String? firmaPath,
    String? fotoEvidenciaPath,
    List<DetailLine>? detailLines,
  }){
    return Remission(id: id?? this.id,
     folio: folio?? this.folio,
      fechaCreacion: fechaCreacion?? this.fechaCreacion,
       nombreVendedor: nombreVendedor?? this.nombreVendedor,
        nombreCliente: nombreCliente?? this.nombreCliente,
          detailLines: detailLines?? this.detailLines,
           firmaPath: firmaPath?? this.firmaPath,
            fotoEvidenciaPath: fotoEvidenciaPath?? this.fotoEvidenciaPath
            );
  }


}