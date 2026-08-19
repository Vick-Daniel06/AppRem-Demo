

import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:equatable/equatable.dart';

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