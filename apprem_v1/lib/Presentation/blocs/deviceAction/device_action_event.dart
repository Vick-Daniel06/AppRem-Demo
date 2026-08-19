import 'package:equatable/equatable.dart';

abstract class DeviceActionEvent extends Equatable{
  const DeviceActionEvent();

  @override
  List<Object?>get props =>[];
}

//Usuario abre la camara
class TakedFotoEvidance extends DeviceActionEvent{}

//Usuario termina de firmar y acepta el lienzo
class SigantureProcessedController extends DeviceActionEvent{
  final dynamic signatureController;
  const SigantureProcessedController(this.signatureController);

  @override
  List<Object?> get props => [];
}