import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_screens.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to AuthBloc
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            // User is authenticated
            return const AuthenticatedScreen();
          } else if (state is AuthLoading) {
            // Authentication in progress
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            // User is unauthenticated
            return const UnauthenticatedScreen();
          }
        },
      ),
    );
  }
}
