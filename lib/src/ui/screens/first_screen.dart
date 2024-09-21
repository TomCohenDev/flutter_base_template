import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // You can handle state changes here if needed
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Test User Screen'),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthUnknown || authState is AuthLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (authState is Unauthenticated) {
                  return _buildUnauthenticated(context);
                } else if (authState is Authenticated) {
                  return _buildAuthenticated(context, authState);
                } else {
                  return Center(child: Text('Unexpected state'));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnauthenticated(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();

              if (email.isNotEmpty && password.isNotEmpty) {
                // Trigger sign-in
                context.read<AuthBloc>().add(SignInRequested(
                      email: email,
                      password: password,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter email and password')),
                );
              }
            },
            child: Text('Sign In'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final email =
                  'tom.cohen99@gmail.com'; //_emailController.text.trim();
              final password = '123456'; //_passwordController.text.trim();

              if (email.isNotEmpty && password.isNotEmpty) {
                // Trigger sign-up
                context.read<AuthBloc>().add(SignUpRequested(
                      email: email,
                      password: password,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter email and password')),
                );
              }
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticated(BuildContext context, Authenticated authState) {
    final userModel = authState.userModel;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Authenticated as: ${authState.authUser.email}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          _buildUserInfo(userModel),
          SizedBox(height: 20),
          _buildUpdateUserForm(context, userModel),
          SizedBox(height: 20),
          _buildDeleteUserButton(context),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Trigger sign-out
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Information:', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Text('UID: ${userModel.uid}'),
        Text('Email: ${userModel.email}'),
        Text('Created Time: ${userModel.createdTime}'),
      ],
    );
  }

  Widget _buildUpdateUserForm(BuildContext context, UserModel userModel) {
    final _emailController = TextEditingController(text: userModel.email);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Update User Email:', style: TextStyle(fontSize: 16)),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            final email = _emailController.text.trim();

            if (email.isNotEmpty) {
              final updatedUser = userModel.rebuild((b) => b..email = email);

              context.read<UserBloc>().add(UpdateUser(updatedUser));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter an email')),
              );
            }
          },
          child: Text('Update Email'),
        ),
      ],
    );
  }

  Widget _buildDeleteUserButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final authUser = context.read<AuthBloc>().state;
        if (authUser is Authenticated) {
          final uid = authUser.authUser.uid;
          context.read<UserBloc>().add(DeleteUser(uid));
        }
      },
      child: Text('Delete User'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }
}
