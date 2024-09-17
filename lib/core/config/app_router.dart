import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  observers: [
    AppNavigatorObserver(onScreenView: (screenName) {
      // final state = navigatorKey.currentState?.context
      //     .findAncestorStateOfType<RevampedAppState>();
      // state?.logScreenView(screenName);
    }),
    AnalyticsService().getAnalyticsObserver(),
  ],
  initialLocation: '/handshake',
  routes: [],
);
