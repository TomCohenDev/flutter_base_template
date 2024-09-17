import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class HandshakeUtils {
  static HandshakeModel get handshake {
    final GetIt getIt = GetIt.instance;
    final HandshakeBloc bloc = getIt<HandshakeBloc>();
    final HandshakeModel? handshake = HandshakeModel(
      isOnline: bloc.state.isOnline,
      localVersion: bloc.state.localVersion,
    );
    return handshake!;
  }
}
