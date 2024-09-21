class DeserializationException implements Exception {
  final String message;
  DeserializationException(this.message);

  @override
  String toString() => 'DeserializationException: $message';
}
