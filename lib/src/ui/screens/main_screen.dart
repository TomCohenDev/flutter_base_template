import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_screens.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is Authenticated) {
          context.goNamed('authenticated');
        } else if (state is Unauthenticated) {
          context.goNamed('unauthenticated');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const AuthenticatedScreen();
          } else if (state is AuthLoadingSignIn ||
              state is AuthLoadingSignUp ||
              state is AuthLoadingDeleteUser ||
              state is AuthLoadingLogout) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const UnauthenticatedScreen();
          }
        },
      ),
    );
  }
}
