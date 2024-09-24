import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_screens.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = AnalyticsRouteObserver();

GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  observers: [
    routeObserver,
  ],
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/authenticated',
      name: 'authenticated',
      builder: (context, state) => const AuthenticatedScreen(),
    ),
    GoRoute(
      path: '/unauthenticated',
      name: 'unauthenticated',
      builder: (context, state) => const UnauthenticatedScreen(),
    ),
  ],
);
