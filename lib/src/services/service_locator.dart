import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  // Repository
  getIt.registerLazySingleton<HandshakeRepository>(() => HandshakeRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(userRepository: getIt<UserRepository>()));
  // Blocs
  getIt.registerLazySingleton<HandshakeBloc>(
      () => HandshakeBloc(handshakeRepository: getIt<HandshakeRepository>()));
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      userRepository: getIt<UserRepository>()));
}
