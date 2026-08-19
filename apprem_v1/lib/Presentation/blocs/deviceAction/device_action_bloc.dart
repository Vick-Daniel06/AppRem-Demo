
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
    try{
      final path = await _cameraService.capturaFotoEvidencia();
      if(path != null){
        emit(SuccessFotoProcess(path));
      }else{
        emit(DeviceActionInitial());
      }
    }catch(e){
      emit(DeviceActionError('Error al acceder a la camara: ${e.toString()}'));
    }
  }

  Future<void> _onSignatureProcessController(SigantureProcessedController event, Emitter<DeviceActionState> emit) async{
    emit(SignatureProcess());
    try{
      // El servicio toma los trazos vectoriales del widget y los exporta a un archivo físico .png
      final path = await _signatureService.guardarFirmaDigital(event.signatureController);

      if(path != null){
        emit(SuccessSignatureProcess(path));
      }else{
        emit(DeviceActionError('El lienzo dew firma esta vacio'));
      }
    }catch(e){
      emit(DeviceActionError('Error al procesar la frima: ${e.toString()}'));
    }
  }
}