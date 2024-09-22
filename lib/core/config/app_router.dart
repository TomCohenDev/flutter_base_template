import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_screens.dart';
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
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    // Optional: If you want to have explicit routes for authenticated and unauthenticated screens
    GoRoute(
      path: '/authenticated',
      builder: (context, state) => const AuthenticatedScreen(),
    ),
    GoRoute(
      path: '/unauthenticated',
      builder: (context, state) => const UnauthenticatedScreen(),
    ),
  ],
);
