
import 'package:equatable/equatable.dart';

class DeviceActionState extends Equatable {
  const DeviceActionState();
  @override
  List<Object?> get props=>[];
}
class DeviceActionInitial extends DeviceActionState{}
//Estados de la camara
class FotoProccess extends DeviceActionState{}
class SuccessFotoProcess extends DeviceActionState{
  final String fotoPath;
  const SuccessFotoProcess(this.fotoPath);
  @override
  List<Object?> get props=>[fotoPath];
}
//Estados de la firma
class SignatureProcess extends DeviceActionState{}
class SuccessSignatureProcess extends DeviceActionState{
  final String signaturePath;
  const SuccessSignatureProcess(this.signaturePath);

  @override
  List<Object?> get props => [signaturePath];
}

//Estado error generico, por rechazo de permisos al hardware
class DeviceActionError extends DeviceActionState{
  final String message;
  const DeviceActionError(this.message);

  @override
  List<Object?> get props => [message];
}
