
import 'package:apprem_v1/Domain/core/result.dart';
import 'package:apprem_v1/Domain/services_interfaces/camera_services.dart';
import 'package:apprem_v1/Domain/services_interfaces/signature_services.dart';
import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_event.dart';
import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceActionBloc extends Bloc<DeviceActionEvent, DeviceActionState> {
  final CameraServices _cameraService;
  final SignatureService _signatureService;

  DeviceActionBloc({required CameraServices cameraServices, required SignatureService signatureService})
  : _cameraService = cameraServices, _signatureService= signatureService, super(DeviceActionInitial()){
    on<TakedFotoEvidance>(_onTakeFotoEvidance);
    on<SigantureProcessedController>(_onSignatureProcessController);
  }

  Future<void> _onTakeFotoEvidance(TakedFotoEvidance event, Emitter<DeviceActionState> emit) async{
    emit(FotoProccess());
    
      final result = await _cameraService.capturaFotoEvidencia();
      
      
      try{
        if(result is Success){
          final success = result as Success<String>;
          final String imagePath = success.data;//String 
        emit(SuccessFotoProcess(imagePath));
        
        }
      else if(result is Failure){
        final failure = result as Failure;
        emit(DeviceActionError(failure.toString()));
        
      
    }
  }catch(e){
    emit(DeviceActionError('Erro al guardar imagen: $e'));
  }
      
  }

  Future<void> _onSignatureProcessController(SigantureProcessedController event, Emitter<DeviceActionState> emit) async{
    emit(SignatureProcess());
    try{
      // El servicio toma los trazos vectoriales del widget y los exporta a un archivo físico .png
      final result = await _signatureService.guardarFirmaDigital(event.signatureController);

      if(result is Success){
        final success = result as Success<String>;
        final String signaturePath = success.data;
        emit(SuccessSignatureProcess(signaturePath));
      }
      else if(result is Failure){
        final failure = result as Failure;
        emit(DeviceActionError(failure.message));
      }
    }catch(e){
      emit(DeviceActionError('Error al procesar firma: $e'));
    } 
  }
}