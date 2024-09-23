// auth_bloc.dart
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  // Subscriptions
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<UserModel?>? _userModelSubscription;

  // Flag to track if session time has been updated in this app session
  bool didUpdateSessionTime = false;

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
    on<UpdateUserRequested>(_onUpdateUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);

    // Start listening to authentication changes
    add(AppStarted());
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    // Cancel previous subscription if any
    _authUserSubscription?.cancel();

    // Listen to authentication state changes
    _authUserSubscription = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        print("Authenticated user: ${authUser.email}");

        // Cancel previous user model subscription
        _userModelSubscription?.cancel();

        // Listen to user data changes
        _userModelSubscription =
            _userRepository.userStream(authUser.uid).listen((userModel) {
          add(AuthUserChanged(authUser: authUser, userModel: userModel));
        });
      } else {
        print("Unauthenticated user");

        // Cancel previous user model subscription
        _userModelSubscription?.cancel();

        add(const AuthUserChanged(authUser: null, userModel: null));
      }
    });
  }

  Future<void> _onAuthUserChanged(
      AuthUserChanged event, Emitter<AuthState> emit) async {
    if (event.authUser != null && event.userModel != null) {
      // Update session time only once per app session
      updateUserSessionTime(event.userModel!);
      emit(Authenticated(
          authUser: event.authUser!, userModel: event.userModel!));
    } else {
      emit(Unauthenticated());
    }
  }

  void updateUserSessionTime(UserModel userModel) async {
    if (!didUpdateSessionTime) {
      await _userRepository.updateUser(
        userModel.rebuild((b) => b..lastSessionTime = DateTime.now()),
      );
      didUpdateSessionTime = true;
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logInWithEmail(
        email: event.email,
        password: event.password,
      );
    } catch (e) {
      emit(AuthError(message: 'Failed to sign in: $e'));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final uid = await _authRepository.signUpWithEmail(
        email: event.email,
        password: event.password,
      );
      // Create user in Firestore
      await _userRepository.createUser(UserModel((b) => b
        ..uid = uid
        ..email = event.email
        ..createdTime = DateTime.now()
        ..lastSessionTime = DateTime.now()));
    } catch (e) {
      emit(AuthError(message: 'Failed to sign up: $e'));
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  // User-related operations
  Future<void> _onUpdateUserRequested(
      UpdateUserRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _userRepository.updateUser(event.user);
      // Fetch updated user model
      final updatedUserModel = await _userRepository.getUser(event.user.uid);
      if (updatedUserModel != null) {
        if (state is Authenticated) {
          final currentState = state as Authenticated;
          emit(Authenticated(
              authUser: currentState.authUser, userModel: updatedUserModel));
        } else {
          emit(AuthError(message: 'User is not authenticated'));
        }
      } else {
        emit(AuthError(message: 'Failed to fetch updated user data'));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to update user: $e'));
    }
  }

  Future<void> _onDeleteUserRequested(
      DeleteUserRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.deleteAuthUser();
      await _userRepository.deleteUser(event.uid);
      print('User ${event.uid} deleted successfully');
      // Optionally sign out the user after deletion
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Failed to delete user: $e'));
    }
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userModelSubscription?.cancel();
    return super.close();
  }
}
