import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Dashboard')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is UpdatingUserData) {
            if (state.status == UpdatingUserDataStatus.updateEmail) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('updating email....')),
              );
            } else if (state.status == UpdatingUserDataStatus.updateName) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('updating name....')),
              );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final userModel = state.userModel;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome, ${userModel.email}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    _buildUserInfo(userModel),
                    const SizedBox(height: 20),
                    _buildUpdateUserForm(context, userModel),
                    const SizedBox(height: 20),
                    _buildDeleteUserButton(context, userModel),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            } else if (state is AuthLoadingSignUp ||
                state is AuthLoadingSignIn ||
                state is AuthLoadingDeleteUser ||
                state is AuthLoadingLogout) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Information:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text('UID: ${userModel.uid}'),
        Text('Name: ${userModel.name}'),
        Text('Email: ${userModel.email}'),
        Text('Created Time: ${userModel.createdTime}'),
        Text('Last Session Time: ${userModel.lastSessionTime}'),
      ],
    );
  }

  Widget _buildUpdateUserForm(BuildContext context, UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._emailForm(context, userModel),
        ..._nameForm(context, userModel),
      ],
    );
  }

  List<Widget> _emailForm(BuildContext context, UserModel userModel) {
    final _emailController = TextEditingController(text: userModel.email);
    return [
      const Text('Update Email:', style: TextStyle(fontSize: 16)),
      TextField(
        controller: _emailController,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          final email = _emailController.text.trim();

          if (email.isNotEmpty) {
            final updatedUser = userModel.rebuild((b) => b..email = email);

            context.read<AuthBloc>().add(UpdateUserRequested(
                updatedUser, UpdatingUserDataStatus.updateEmail));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter an email')),
            );
          }
        },
        child: const Text('Update Email'),
      ),
    ].toList();
  }

  List<Widget> _nameForm(BuildContext context, UserModel userModel) {
    final _nameController = TextEditingController(text: userModel.name);
    return [
      const Text('Update Name:', style: TextStyle(fontSize: 16)),
      TextField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          final name = _nameController.text.trim();

          if (name.isNotEmpty) {
            final updatedUser = userModel.rebuild((b) => b..name = name);

            context.read<AuthBloc>().add(UpdateUserRequested(
                updatedUser, UpdatingUserDataStatus.updateName));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a name')),
            );
          }
        },
        child: const Text('Update Name'),
      ),
    ].toList();
  }

  Widget _buildDeleteUserButton(BuildContext context, UserModel userModel) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(DeleteUserRequested(userModel.uid));
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('Delete User'),
    );
  }
}
