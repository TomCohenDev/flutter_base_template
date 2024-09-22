// auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthUnknown extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final auth.User authUser;
  final UserModel userModel;

  const Authenticated({required this.authUser, required this.userModel});

  @override
  List<Object?> get props => [authUser, userModel];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
