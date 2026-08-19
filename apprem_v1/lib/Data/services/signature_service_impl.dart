
import 'dart:io';
import 'dart:typed_data';

import 'package:apprem_v1/Domain/services_interfaces/signature_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SignatureServiceImpl implements SignatureService {

@override
  Future<String?> guardarFirmaDigital(Uint8List bytes) async{
    try{
      //obtener la ruta del directorio de la app
      final directory = await getApplicationDocumentsDirectory();
      //crea la carpeta exclusiva
      final signaturePath = Directory(p.join(directory.path, 'signature'));
      if(!await signaturePath.exists()){
        await signaturePath.create(recursive: true);
      }
      //genera el nombre unico del archivo utilizando una marca de tiempo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'firma_$timestamp.png';
      final permanentPath = p.join(signaturePath.path, fileName);
      //crea el archivo fisico y escibir los bytes puros directamente en el disco
      final File signatureArchive = File(permanentPath);
      await signatureArchive.writeAsBytes(bytes);
      //retorna el path absoluto para que pueda ser guardado en la Remision de Drift
      return signatureArchive.path;
    }catch(e){
      print('Error critico al escribir el archivo de firma: $e');
      return null;
    }
  }

}