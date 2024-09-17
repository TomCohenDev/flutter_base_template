part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final auth.User? authUser;
  final UserModel? userModel;
  final bool? shouldUpdateState;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.authUser,
    this.userModel,
    this.shouldUpdateState = false,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticated({
    required auth.User authUser,
    required UserModel userModel,
  }) : this._(
            status: AuthStatus.authenticated,
            authUser: authUser,
            userModel: userModel);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, authUser, userModel];
}
