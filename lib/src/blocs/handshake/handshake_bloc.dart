import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:revampedai/src/repositories/handshake_repo.dart';
import 'package:revampedai/src/services/firebase_analytics/analytics.dart';

part 'handshake_event.dart';
part 'handshake_state.dart';

class HandshakeBloc extends Bloc<HandshakeEvent, HandshakeState> {
  final HandshakeRepository _handshakeRepository;
  HandshakeBloc({
    required HandshakeRepository handshakeRepository,
  })  : _handshakeRepository = handshakeRepository,
        super(HandshakeState.initial()) {
    on<CheckHandshake>(_onCheckHandshake);
    on<ShowDialog>(_onShowDialog);
    add(CheckHandshake());
  }

  FutureOr<void> _onCheckHandshake(
      CheckHandshake event, Emitter<HandshakeState> emit) async {
    emit(HandshakeState.checkingHandshake());

    try {
      final handshake = await _handshakeRepository.getHandshakeData();
      if (handshake == null) {
        emit(HandshakeState.handshakeChecked(
            handshakeStatus: HandshakeStatus.handshakeError));
        return;
      }
      print('handshake checked');
      handshake.printData();
      emit(HandshakeState.handshakeChecked(
        handshakeStatus: HandshakeStatus.handshakeOK,
        isAppOnline: handshake.isAppOnline,
        localAppVersion: handshake.localAppVersion,
        lastestRemoteAppVersion: handshake.lastestRemoteAppVersion,
        isUpdateAvailable: handshake.isUpdateAvailable,
        isUpdateRequired: handshake.isUpdateRequired,
        startAppDialogtitle: handshake.startAppDialogtitle,
        startAppDialogDescription: handshake.startAppDialogDescription,
        showStartAppDialog: handshake.showStartAppDialog,
      ));
    } catch (error) {
      print('handshake error: $error');
      emit(HandshakeState.handshakeChecked(
          handshakeStatus: HandshakeStatus.handshakeError));
    }
  }

  HandshakeState checkHandshake() {
    return HandshakeState.checkingHandshake();
  }

  FutureOr<void> _onShowDialog(
      ShowDialog event, Emitter<HandshakeState> emit) {}
}
