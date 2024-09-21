part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class CreateUser extends UserEvent {
  final UserModel user;

  const CreateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UserEvent {
  final UserModel user;

  const UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUser extends UserEvent {
  final String uid;

  const DeleteUser(this.uid);

  @override
  List<Object?> get props => [uid];
}
