import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class UnauthenticatedScreen extends StatelessWidget {
  const UnauthenticatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController =
        TextEditingController(text: 'tom.cohen99@gmail.com');
    final _passwordController = TextEditingController(text: '123456');

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In / Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password Field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Sign In Button
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  context.read<AuthBloc>().add(SignInRequested(
                        email: email,
                        password: password,
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter email and password')),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  context.read<AuthBloc>().add(SignUpRequested(
                        email: email,
                        password: password,
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter email and password')),
                  );
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
