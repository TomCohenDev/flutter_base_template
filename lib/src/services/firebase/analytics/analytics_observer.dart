import 'package:flutter_app/indexes/indexes_packages.dart';

class AppNavigatorObserver extends NavigatorObserver {
  final Function(String screenName) onScreenView;

  AppNavigatorObserver({required this.onScreenView});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      onScreenView(route.settings.name!);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name != null) {
      onScreenView(previousRoute!.settings.name!);
    }
  }
}
