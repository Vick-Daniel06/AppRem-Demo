import 'dart:io';

import 'package:apprem_v1/Domain/services_interfaces/camera_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class CameraServiceImpl implements CameraServices{
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> capturaFotoEvidencia() async{
    try{
      //Abrir la camara nativa con optimizacion de tamano y calidad
      final XFile? temporalFoto = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024, imageQuality: 85);
      if(temporalFoto == null) return null;//Si el usario decide cerrar la camara
      //el directorio de la app
      final directory = await getApplicationDocumentsDirectory();
      //se crea la carpeta exclusiva para las evidencias si no existe
      final evidanceFile = Directory(p.join(directory.path, 'evidance'));
      if(!await evidanceFile.exists()){
        await evidanceFile.create(recursive: true);
      }
      //genera un nombre unico, evitando que se sobreescriban
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'evidance_$timestamp.jpg';
      final permanentPath = p.join(evidanceFile.path, fileName);
      //Mover el archivo de la carpeta temporal del sistema a la carpeta permanente
      final File saveFoto = await File(temporalFoto.path).copy(permanentPath);

      return saveFoto.path; //Se regresa la ruta para el BLoC se le asigne a la Rem
    }catch(e){
      print('Error al capturar la foto: $e');
      return null;
    }
  }

}