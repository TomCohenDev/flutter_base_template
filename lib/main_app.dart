import 'package:flutter/foundation.dart';
import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_core.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb)
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getIt<HandshakeRepository>()),
        RepositoryProvider.value(value: getIt<UserRepository>()),
        RepositoryProvider.value(value: getIt<AuthRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HandshakeBloc>(
              create: (context) => getIt<HandshakeBloc>()),
          BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
          BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.2);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale)
                      .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.3)),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: state.themeData,
                routerConfig: router,
              ),
            );
          },
        ),
      ),
    );
  }
}
