import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/indexes/indexes_models.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserActionInProgress());
    try {
      await userRepository.createUser(event.user);
      emit(UserActionSuccess(event.user));
    } catch (e) {
      emit(UserActionFailure('Failed to create user: $e'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserActionInProgress());
    try {
      await userRepository.updateUser(event.user);
      emit(UserActionSuccess(event.user));
    } catch (e) {
      emit(UserActionFailure('Failed to update user: $e'));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(UserActionInProgress());
    try {
      await userRepository.deleteUser(event.uid);
      emit(UserInitial());
    } catch (e) {
      emit(UserActionFailure('Failed to delete user: $e'));
    }
  }
}
