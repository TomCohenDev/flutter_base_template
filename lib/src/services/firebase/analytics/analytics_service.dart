// analytics_service.dart

import 'dart:math';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';
import 'package:flutter_app/src/utils/console_log.dart'; // Import the ConsoleLogger

const maxEventNameLength = 40;
const maxParameterLength = 100;

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static const bool enableAnalytics = true;
  static const bool enableDevTag = false;

  // Encapsulated variables
  late final String sessionId;
  bool devMode = true;

  // Singleton pattern
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal() {
    sessionId = _createSessionId();
  }

  // Private method to create a random session id
  String _createSessionId() {
    final random = Random();
    return random.nextInt(1000000000).toString();
  }

  // Method to set the current screen
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );

    // Log to console using ConsoleLogger
    ConsoleLogger().log(
      type: 'screen view',
      name: screenName,
      sessionId: sessionId,
    );
  }

  // Method to log events
  Future<void> logEvent(
    String eventName, {
    Map<String, Object?>? parameters,
  }) async {
    try {
      // Validate event name length
      if (eventName.length > maxEventNameLength) {
        throw ArgumentError(
          'Event name must be $maxEventNameLength characters or less',
        );
      }

      // Initialize parameters if null
      parameters ??= {};

      // Get user information
      final uid = AuthUtils.currentUserId ?? 'unset';
      final email = AuthUtils.currentUser?.email ?? 'unset';

      // Add default parameters
      parameters.addAll({
        'user': uid,
        'email': email,
        'dev_mode': devMode,
        'session_id': sessionId,
      });

      // Remove entries where values are null
      parameters.removeWhere((k, v) => v == null);

      // Truncate string parameters to max length
      final Map<String, Object> truncatedParams = parameters.map((k, v) {
        Object value = v!;
        if (v is String && v.length > maxParameterLength) {
          value = v.substring(0, maxParameterLength);
        }
        return MapEntry(k, value);
      });

      if (enableAnalytics) {
        // Log the event to Firebase Analytics
        await _analytics.logEvent(
          name: eventName,
          parameters: truncatedParams,
        );
      }

      // Log to console using ConsoleLogger
      ConsoleLogger().log(
        type: 'event',
        name: eventName,
        parameters: truncatedParams,
        sessionId: sessionId,
      );
    } catch (e) {
      // Handle any errors
      print('Error logging event: $e');
    }
  }
}
