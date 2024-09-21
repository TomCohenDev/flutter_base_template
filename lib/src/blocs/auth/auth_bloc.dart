// auth_bloc.dart
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final DateTime sessionStartTime = DateTime.now();
  bool didUpdatedSessionTime = false;

  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthUnknown()) {
    on<AppStarted>(_onAppStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    // Listen to authentication state changes
    add(AppStarted());
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    _authUserSubscription = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        print("Authenticated user: ${authUser.email}");
        // Listen to user data changes
        _userSubscription?.cancel();
        _userSubscription =
            _userRepository.userStream(authUser.uid).listen((userModel) {
          add(AuthUserChanged(authUser: authUser, userModel: userModel));
        });
      } else {
        // User is not signed in
        print("Unauthenticated user");
        add(const AuthUserChanged(authUser: null));
      }
    });
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logInWithEmail(
        email: event.email,
        password: event.password,
      );
      // The auth state change listener will handle state updates
    } catch (e) {
      emit(AuthError(message: 'Failed to sign in: $e'));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final string = await _authRepository.signUpWithEmail(
        email: event.email,
        password: event.password,
      );
      await _userRepository.createUser(UserModel((b) => b
        ..uid = string
        ..email = event.email
        ..createdTime = DateTime.now()
        ..lastSettionTime = DateTime.now()));
    } catch (e) {
      emit(AuthError(message: 'Failed to sign up: $e'));
    }
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.authUser != null && event.userModel != null) {
      if (!didUpdatedSessionTime) {
        _userRepository.updateUser(event.userModel!
            .rebuild((b) => b..lastSettionTime = DateTime.now()));
        didUpdatedSessionTime = true;
      }
      emit(Authenticated(
          authUser: event.authUser!, userModel: event.userModel!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
