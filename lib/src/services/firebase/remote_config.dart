import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService._internal(this._remoteConfig);

  static Future<RemoteConfigService> create() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set default values
    await remoteConfig.setDefaults({
      'latest_app_version': '1.0.0',
      'is_app_active': true,
    });

    // Fetch and activate remote config values
    await remoteConfig.fetchAndActivate();

    return RemoteConfigService._internal(remoteConfig);
  }

  String get latestAppVersion => _remoteConfig.getString('latest_app_version');
  bool get isAppActive => _remoteConfig.getBool('is_app_active');
}
