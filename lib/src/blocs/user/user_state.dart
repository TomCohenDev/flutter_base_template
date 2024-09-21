part of 'user_bloc.dart';


abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserActionInProgress extends UserState {}

class UserActionSuccess extends UserState {
  final UserModel user;

  const UserActionSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class UserActionFailure extends UserState {
  final String error;

  const UserActionFailure(this.error);

  @override
  List<Object?> get props => [error];
}