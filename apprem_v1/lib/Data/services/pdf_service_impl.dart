import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:apprem_v1/Domain/entities/remission.dart';
import 'package:apprem_v1/Domain/services_interfaces/pdf_services.dart';

class PdfServiceImpl implements PdfServices {
  @override
   Future<String?> generarPdfYCompartir(Remission remission) async{

    try{
      final pdf = pw.Document();

      pw.MemoryImage? signatureImage;
      final pathSignature = remission.firmaPath;
      if( pathSignature.isNotEmpty && await File(remission.firmaPath).exists()){
        final signatureBytes = await File(pathSignature).readAsBytes();
        signatureImage = pw.MemoryImage(signatureBytes);
      }
      
      pw.MemoryImage? evidanceImage;
      final pathImage = remission.fotoEvidenciaPath;
      if(pathImage != null && pathImage.isNotEmpty && await File(pathImage).exists()){
        final evidanceBytes = await File(pathImage).readAsBytes();
        evidanceImage = pw.MemoryImage(evidanceBytes);
      }

      final dataTable = remission.detailLines.map((linea) {
                  final importe = linea.cantidad * linea.precioUnitarioEnEseMomento;
                  return [
                    linea.nombreProducto,
                    linea.cantidad.toString(),
                    '\$${linea.precioUnitarioEnEseMomento.toStringAsFixed(2)}',
                    '\$${importe.toStringAsFixed(2)}',
                  ];
                }).toList();
      final granTotal = remission.detailLines.fold<double>(
        0.0,
        (sum, item) => sum + (item.cantidad * item.precioUnitarioEnEseMomento),
      );

pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // CABECERA DEL DOCUMENTO
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('DOCUMENTO DE REMISIÓN', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.Text(remission.folio, style: pw.TextStyle(fontSize: 18, color: PdfColors.blue800, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),

              // DATOS INFORMATIVOS
              pw.Text('Fecha de Emisión: ${remission.fechaCreacion.toLocal().toString().split(' ')[0]}'),
              pw.Text('Cliente: ${remission.nombreCliente}'),
              pw.Text('Vendedor: ${remission.nombreVendedor}'),
              pw.SizedBox(height: 20),

              // TABLA DE RENGLONES (Detalle de la mercancía)
              pw.Text('Detalle de Productos:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
                headers: ['Producto', 'Cant.', 'Precio Unit.', 'Importe'],
                data: dataTable,
              ),
              pw.SizedBox(height: 10),

              //Fila granTotal a la derecha
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'TOTAL: \$${granTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 30),

              // SECCIÓN DE EVIDENCIAS Y FIRMA (Cierre del contrato)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Lado Izquierdo: Foto de Evidencia
                  pw.Column(
                    children: [
                      pw.Text('Evidencia Física', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      evidanceImage != null 
                        ? pw.Image(evidanceImage, width: 120, height: 120, fit: pw.BoxFit.cover)
                        : pw.Container(width: 120, height: 120, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)), child: pw.Center(child: pw.Text('Sin foto Fisica', style: const pw.TextStyle(color: PdfColors.green200)))),
                    ],
                  ),
                  // Lado Derecho: Firma Digital del Cliente
                  pw.Column(
                    children: [
                      pw.Text('Firma de Conformidad', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      signatureImage != null 
                        ? pw.Image(signatureImage, width: 150, height: 80, fit: pw.BoxFit.contain) 
                        : pw.Container(width: 150, height: 80, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)), child: pw.Center(child: pw.Text('Firma Pendiente', style: const pw.TextStyle(color: PdfColors.grey500)))),
                        
                      pw.SizedBox(height: 5),
                      pw.Container(width: 160, height: 1, color: PdfColors.black),
                    ],
                  ),
                ],
              ),
            ];
          },
        ),
      );
      final output = await getApplicationDocumentsDirectory();
      final pdfFile = Directory(p.join(output.path, 'remisiones_pdf'));
      if(!await pdfFile.exists()){
        await pdfFile.create(recursive: true);
      }

      final fileName = 'remision_${remission.folio}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(p.join(pdfFile.path, fileName));

      await file.writeAsBytes(await pdf.save());

      return file.path;
    }catch(e){
      print('Error critico durante el renderzado de PDF: $e');
      return null;
    }
   }
}