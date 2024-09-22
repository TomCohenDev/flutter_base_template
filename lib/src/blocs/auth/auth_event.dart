// auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final auth.User? authUser;
  final UserModel? userModel;

  const AuthUserChanged({required this.authUser, required this.userModel});

  @override
  List<Object?> get props => [authUser, userModel];
}

class AuthLogoutRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// User-related events
class UpdateUserRequested extends AuthEvent {
  final UserModel user;

  const UpdateUserRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserRequested extends AuthEvent {
  final String uid;

  const DeleteUserRequested(this.uid);

  @override
  List<Object?> get props => [uid];
}
