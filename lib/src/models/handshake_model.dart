import 'package:flutter_app/indexes/indexes_packages.dart';

class HandshakeModel {
  final bool? isOnline;
  final String? localVersion;

  HandshakeModel({
    this.isOnline,
    this.localVersion,
  });

  factory HandshakeModel.fromFirestore(
      Map<String, dynamic> doc, PackageInfo packageInfo) {
    return HandshakeModel(
        isOnline: doc['is_app_online'], localVersion: packageInfo.version);
  }
}
