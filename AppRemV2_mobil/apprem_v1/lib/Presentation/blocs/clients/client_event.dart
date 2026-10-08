

import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:equatable/equatable.dart';
//EQUATABLE AL COMPARA OBJETOS, SI HAY UN ERROR Y DA OTRA VEZ EL ERROR YA NO LO MUESTRA LA SEGUNDA VEZ POR QUE CREE QUE ES LO MISMO

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientEvent extends ClientEvent{}

class AddClientEvent extends ClientEvent{
  final Client client;
  const AddClientEvent(this.client);

  @override
  List<Object?> get props => [client];
}
class UpdateClientEvent extends ClientEvent{
  final Client client;
  const UpdateClientEvent(this.client);

  @override
  List<Object?> get props => [client];
}
class DeleteClientEvent extends ClientEvent{
  final String id;
  const DeleteClientEvent(this.id);
  @override 
  List<Object?> get props => [id];
}