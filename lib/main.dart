import 'package:flutter_app/indexes/indexes_core.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

final GetIt getIt = GetIt.instance;
// ===== UNCOMMENT THIS LINE =====
// late FirebaseAnalytics analytics;
// ===== UNCOMMENT THIS LINE =====
// late FirebaseAnalytics analytics;
String sessionId = "unset";

void setupLocator() {
  // getIt.registerLazySingleton<HandshakeBloc>(() => HandshakeBloc(
  //       handshakeRepository: getIt<HandshakeRepository>(),
  //     ));

  // getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  // getIt.registerLazySingleton<AuthRepository>(
  //     () => AuthRepository(userRepository: getIt<UserRepository>()));

  // getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
  //       authRepository: getIt<AuthRepository>(),
  //       userRepository: getIt<UserRepository>(),
  //     ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== UNCOMMENT THIS LINE =====
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ===== UNCOMMENT THIS LINE =====
  //   analytics = FirebaseAnalytics.instance;
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  setupLocator();
  await GetStorage.init();

  runApp(const MainApp());
}
