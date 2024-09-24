import 'package:flutter_app/src/services/service_locator.dart';
import 'package:flutter_app/indexes/indexes_core.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';
import 'package:flutter_app/src/services/firebase/firebase_init.dart';
import 'package:flutter_app/src/services/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await initializeGetStorage();
  setupLocator();
  runApp(const MainApp());
}
