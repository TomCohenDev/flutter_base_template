import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';
part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  final AuthRepository _authRepository;
  AuthScreenCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthScreenState.initial());
}
