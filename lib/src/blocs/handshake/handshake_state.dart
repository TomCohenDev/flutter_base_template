part of 'handshake_bloc.dart';

enum HandshakeStatus {
  initial,
  connactivityError,
  checkingHandshake,
  handshakeChecked,

  handshakeOK,
  handshakeError
}

class HandshakeState extends Equatable {
  final HandshakeStatus handshakeStatus;
  final bool? isAppOnline;
  final String? localAppVersion;
  final String? lastestRemoteAppVersion;
  final bool? isUpdateAvailable;
  final bool? isUpdateRequired;
  final String? startAppDialogtitle;
  final String? startAppDialogDescription;
  final bool? showStartAppDialog;

  const HandshakeState._({
    this.handshakeStatus = HandshakeStatus.initial,
    this.isAppOnline,
    this.localAppVersion,
    this.lastestRemoteAppVersion,
    this.isUpdateAvailable,
    this.isUpdateRequired,
    this.startAppDialogtitle,
    this.startAppDialogDescription,
    this.showStartAppDialog,
  });

  const HandshakeState.initial()
      : this._(handshakeStatus: HandshakeStatus.initial);
  const HandshakeState.connactivityError()
      : this._(handshakeStatus: HandshakeStatus.connactivityError);

  const HandshakeState.checkingHandshake()
      : this._(handshakeStatus: HandshakeStatus.checkingHandshake);

  const HandshakeState.handshakeChecked({
    required HandshakeStatus handshakeStatus,
    bool? isAppOnline,
    String? localAppVersion,
    String? lastestRemoteAppVersion,
    bool? isUpdateAvailable,
    bool? isUpdateRequired,
    bool? isUpdate,
    String? startAppDialogtitle,
    String? startAppDialogDescription,
    bool? showStartAppDialog,
  }) : this._(
          handshakeStatus: handshakeStatus,
          isAppOnline: isAppOnline,
          localAppVersion: localAppVersion,
          lastestRemoteAppVersion: lastestRemoteAppVersion,
          isUpdateAvailable: isUpdateAvailable,
          isUpdateRequired: isUpdateRequired,
          startAppDialogtitle: startAppDialogtitle,
          startAppDialogDescription: startAppDialogDescription,
          showStartAppDialog: showStartAppDialog,
        );

  @override
  List<Object?> get props => [
        isAppOnline,
        localAppVersion,
        lastestRemoteAppVersion,
        isUpdateAvailable,
        isUpdateRequired,
        startAppDialogtitle,
        startAppDialogDescription,
        showStartAppDialog,
      ];

  HandshakeState copyWith({
    HandshakeStatus? handshakeStatus,
    bool? isAppOnline,
    String? localAppVersion,
    String? lastestRemoteAppVersion,
    bool? isUpdateAvailable,
    bool? isUpdateRequired,
    String? startAppDialogtitle,
    String? startAppDialogDescription,
    bool? showStartAppDialog,
  }) {
    return HandshakeState._(
      handshakeStatus: handshakeStatus ?? this.handshakeStatus,
      isAppOnline: isAppOnline ?? this.isAppOnline,
      localAppVersion: localAppVersion ?? this.localAppVersion,
      lastestRemoteAppVersion:
          lastestRemoteAppVersion ?? this.lastestRemoteAppVersion,
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      isUpdateRequired: isUpdateRequired ?? this.isUpdateRequired,
      startAppDialogtitle: startAppDialogtitle ?? this.startAppDialogtitle,
      startAppDialogDescription:
          startAppDialogDescription ?? this.startAppDialogDescription,
      showStartAppDialog: showStartAppDialog ?? this.showStartAppDialog,
    );
  }
}
