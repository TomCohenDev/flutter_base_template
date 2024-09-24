import 'package:get_storage/get_storage.dart';

Future<void> initializeGetStorage() async {
  await GetStorage.init();
}
