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






}
