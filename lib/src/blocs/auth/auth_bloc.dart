import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  AuthBloc({
    required authRepository,
    required userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<UserUpdated>(_onUserUpdated);
    on<DeleteUserRequest>(_onDeleteUserRequest);

    _authUserSubscription = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        print("auth user: ${authUser.email}");
        _userRepository.userStream(authUser.uid).listen((userModel) {
          add(AuthUserChanged(authUser: authUser, userModel: userModel));
        });
      } else {
        add(AuthUserChanged(authUser: authUser));
      }
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    event.authUser != null && event.userModel != null
        ? emit(AuthState.authenticated(
            authUser: event.authUser!, userModel: event.userModel!))
        : emit(AuthState.unauthenticated());
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(AuthState.unauthenticated());
  }

  void _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) async {
    await _userRepository.updateUser(event.userModel);
    emit(AuthState.authenticated(
        authUser: auth.FirebaseAuth.instance.currentUser!,
        userModel: event.userModel));
  }

  FutureOr<void> _onDeleteUserRequest(
      DeleteUserRequest event, Emitter<AuthState> emit) async {
    final isDeleted = await _authRepository.deleteAuthUser(event.password);
    if (isDeleted) {
      emit(const AuthState.unauthenticated());
    }
  }

  String? getUserProvider() {
    return _authRepository.getUserProvider();
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
