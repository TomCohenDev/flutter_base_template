import 'package:flutter_app/indexes/indexes_core.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

const kMaxEventNameLength = 40;
const kMaxParameterLength = 100;

class AnalyticsLogger {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static const enableAnalytics = true;
  static const enableDevTag = false;

  static int counter = 0;

  static void logEvent(String eventName, {Map<String?, dynamic>? parameters}) {
    try {
      // Validate event name length
      assert(eventName.length <= kMaxEventNameLength,
          'Event name must be $kMaxEventNameLength characters or less');

      // Initialize parameters if null
      parameters ??= {};
      final isdev = enableDevTag ? 'dev_' : '';
      final uid =
          AuthUtils.currentUserId == null || AuthUtils.currentUserId!.isEmpty
              ? 'unset'
              : AuthUtils.currentUserId!;
      // final email =
      //     AuthUtils.currentUserId == null || AuthUtils.currentUserId!.isEmpty
      //         ? 'unset'
      //         : AuthUtils.currentUser.email!;
      final versionLocal = HandshakeUtils.handshake.localVersion ?? "N/A";

      parameters.putIfAbsent('user', () => uid);
      // parameters.putIfAbsent('email', () => email);
      parameters.putIfAbsent('version', () => isdev + versionLocal);
      parameters.putIfAbsent('dev_mode', () => devMode);
      parameters.putIfAbsent('session_id', () => sessionId);

      parameters.removeWhere((k, v) => k == null || v == null);

      // Convert parameters to string and ensure they don't exceed max length
      final params = parameters.map((k, v) => MapEntry(k!, v));
      for (final entry in params.entries) {
        if (entry.value is! num) {
          var valStr = entry.value.toString();
          if (valStr.length > kMaxParameterLength) {
            valStr =
                valStr.substring(0, min(valStr.length, kMaxParameterLength));
          }
          params[entry.key] = valStr;
        }
      }
      if (enableAnalytics) {
        // Log the event to Firebase Analytics
        _analytics.logEvent(name: eventName, parameters: params);

        // Log the event to Singular
      }

      // Print the event name and parameters to the terminal
      counter++;

      print('---------------------------');
      print('ANALYTICS event number: $counter');
      print('Logging event: $eventName');
      print('Parameters: $params');
      print('---------------------------\n\n');
    } catch (e) {
      // Handle any errors
      print('Error logging event: $e');
    }
  }

  static void logScreenView(String screenName) {
    try {
      // Validate screen name length
      assert(screenName.length <= kMaxEventNameLength,
          'Screen name must be $kMaxEventNameLength characters or less');

      // Log the screen view
      logEvent("screen_view_$screenName",
          parameters: {"screen_name": screenName});
    } catch (e) {
      // Handle any errors
      print('Error logging screen view: $e');
    }
  }

// a funtion to create a random session id
  static String createSessionId() {
    final random = Random();
    final sessionId = random.nextInt(1000000000);
    return sessionId.toString();
  }
}
