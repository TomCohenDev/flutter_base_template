// auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthUnknown extends AuthState {}

class AuthLoadingSignIn extends AuthState {}

class AuthLoadingSignUp extends AuthState {}

class AuthLoadingLogout extends AuthState {}

class AuthLoadingDeleteUser extends AuthState {}

class Authenticated extends AuthState {
  final auth.User authUser;
  final UserModel userModel;
  const Authenticated({
    required this.authUser,
    required this.userModel,
  });
  @override
  List<Object?> get props => [
        authUser,
        userModel,
      ];
}

enum UpdatingUserDataStatus { non, updateEmail, updateName, logout }

class UpdatingUserData extends Authenticated {
  final UpdatingUserDataStatus status;
  const UpdatingUserData(
      {required super.authUser,
      required super.userModel,
      required this.status});
  @override
  List<Object?> get props => [authUser, userModel, status];
}

class UpdateUserDataSuccess extends Authenticated {
  final UpdatingUserDataStatus status;
  const UpdateUserDataSuccess({
    required super.authUser,
    required super.userModel,
    required this.status,
  });

  @override
  List<Object?> get props => [authUser, userModel, status];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}
