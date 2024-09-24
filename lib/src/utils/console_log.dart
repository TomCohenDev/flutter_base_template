// console_logger.dart

class ConsoleLogger {
  // Singleton pattern
  static final ConsoleLogger _instance = ConsoleLogger._internal();

  factory ConsoleLogger() => _instance;

  ConsoleLogger._internal();

  // Counters for different log types
  final Map<String, int> _counters = {};

  void log({
    required String type,
    required String name,
    String? sessionId,
    Map<String, Object>? parameters,
  }) {
    // Increment the counter for the given type
    _counters[type] = (_counters[type] ?? 0) + 1;
    final counter = _counters[type]!;

    // Build the log message
    final buffer = StringBuffer();
    buffer.writeln('---------------------------');
    buffer.writeln('ANALYTICS $type number: $counter');
    buffer.writeln('Logging $type: $name');
    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('Parameters: $parameters');
    }
    if (sessionId != null) {
      buffer.writeln('Session ID: $sessionId');
    }
    buffer.writeln('---------------------------\n');

    // Print the log message
    print(buffer.toString());
  }
}
