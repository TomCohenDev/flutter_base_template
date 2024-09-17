part of 'handshake_bloc.dart';

sealed class HandshakeEvent extends Equatable {
  const HandshakeEvent();

  @override
  List<Object> get props => [];
}

class CheckHandshake extends HandshakeEvent {
  const CheckHandshake();
}

class CheckConnectionActivity extends HandshakeEvent {
  const CheckConnectionActivity();
}

class ShowDialog extends HandshakeEvent {
  const ShowDialog();
}
