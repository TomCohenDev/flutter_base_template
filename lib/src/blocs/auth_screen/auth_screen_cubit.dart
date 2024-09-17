import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:revampedai/src/models/user_model.dart';
import 'package:revampedai/src/repositories/auth_repo.dart';
import 'package:revampedai/src/services/firebase_analytics/analytics.dart';
import 'package:revampedai/src/utils/auth_response.dart';
part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  final AuthRepository _authRepository;
  AuthScreenCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthScreenState.initial());

  void isLoginSuccesful(AuthResponse authResponse) {
    if (authResponse.success) {
      emit(state.copyWith(status: AuthScreenStatus.success));
    } else {
      emit(state.copyWith(
        status: AuthScreenStatus.error,
        authResponse: authResponse,
      ));
      emit(state.copyWith(status: AuthScreenStatus.initial));
    }
  }



  Future<void> logInWithGoogle() async {
    if (state.status == AuthScreenStatus.submitting) return;
    emit(state.copyWith(status: AuthScreenStatus.submitting));
    try {
      final loginStatus = await _authRepository.logInWithGoogle();
      isLoginSuccesful(loginStatus);
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(state.copyWith(
        status: AuthScreenStatus.error,
        authResponse: AuthResponse(
          success: false,
          errorMessage: e.toString(),
        ),
      ));
      print(e);
    }
  }

  Future<void> fogotPassword(String email) async {
    try {
      await _authRepository.forgotPassword(email);
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(
        state.copyWith(
          status: AuthScreenStatus.error,
          authResponse: AuthResponse(
            success: false,
            errorMessage: e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  Future<void> logInWithApple() async {
    if (state.status == AuthScreenStatus.submitting) return;
    emit(state.copyWith(status: AuthScreenStatus.submitting));
    try {
      final loginStatus = await _authRepository.logInWithApple();

      isLoginSuccesful(loginStatus);
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(
        state.copyWith(
          status: AuthScreenStatus.error,
          authResponse: AuthResponse(
            success: false,
            errorMessage: e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  Future<void> logInWithFacebook() async {
    if (state.status == AuthScreenStatus.submitting) return;
    emit(state.copyWith(status: AuthScreenStatus.submitting));
    try {
      final loginStatus = await _authRepository.logInWithFacebook();
      isLoginSuccesful(loginStatus);
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(
        state.copyWith(
          status: AuthScreenStatus.error,
          authResponse: AuthResponse(
            success: false,
            errorMessage: e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  Future<void> logInWithCredentials() async {
    if (state.status == AuthScreenStatus.submitting) return;
    emit(state.copyWith(status: AuthScreenStatus.submitting));
    try {
      final loginStatus = await _authRepository.logInWithEmail(
          email: state.userModel!.email!, password: state.password);
      isLoginSuccesful(loginStatus);
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(
        state.copyWith(
          status: AuthScreenStatus.error,
          authResponse: AuthResponse(
            success: false,
            errorMessage: e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  Future<void> signUpWithCredentials() async {
    if (state.status == AuthScreenStatus.submitting) return;
    emit(state.copyWith(status: AuthScreenStatus.submitting));

    try {
      var signUpResult = await _authRepository.signUpWithEmail(
          userModel: state.userModel!, password: state.password);
      if (signUpResult.user != null) {
        emit(state.copyWith(
            status: AuthScreenStatus.success, authUser: signUpResult.user));
      } else {
        emit(
          state.copyWith(
            status: AuthScreenStatus.error,
            authResponse: AuthResponse(
              success: false,
              errorMessage: signUpResult.errorMessage,
              errorCode: signUpResult.errorCode,
            ),
          ),
        );
      }
    } catch (e) {
      AnalyticsLogger.logEvent('auth_error', parameters: {
        'message': e.toString(),
      });
      emit(
        state.copyWith(
          status: AuthScreenStatus.error,
          authResponse: AuthResponse(
            success: false,
            errorMessage: e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  void userChanged(UserModel userModel) {
    print(userModel.email);
    emit(state.copyWith(
      userModel: userModel,
      status: AuthScreenStatus.initial,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      status: AuthScreenStatus.initial,
    ));
  }

  void confrimPasswordChanged(String confirmPassword) {
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: AuthScreenStatus.initial,
    ));
  }

  void authFromModeChanged(bool isLoginMode) {
    emit(state.copyWith(
      isLoginMode: !isLoginMode,
      status: AuthScreenStatus.initial,
    ));
  }

  void obscurePasswordToggle(bool obscurePassword) {
    emit(state.copyWith(
      obscurePassword: !obscurePassword,
      status: AuthScreenStatus.initial,
    ));
  }

  void obscureConfirmPasswordToggle(bool obscureConfirmPassword) {
    emit(state.copyWith(
      obscureConfirmPassword: !obscureConfirmPassword,
      status: AuthScreenStatus.initial,
    ));
  }
}
