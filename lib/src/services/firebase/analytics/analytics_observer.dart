// analytics_route_observer.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/indexes/indexes_services.dart';
import 'package:flutter_app/src/services/service_locator.dart';

class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    if (screenName != null) {
      // Optional: Log when a screen view is being sent
      getIt<AnalyticsService>().setCurrentScreen(screenName: screenName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      _sendScreenView(route);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute is PageRoute) {
      _sendScreenView(previousRoute);
    }
    super.didPop(route, previousRoute);
  }
}
