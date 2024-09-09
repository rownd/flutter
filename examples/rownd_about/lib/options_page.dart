import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rownd_flutter_plugin/rownd_cubit.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key, required this.toggleOptions});

  final VoidCallback toggleOptions;

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<RowndCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        authCubit.isAuthenticated()
            ? SignOutButton(toggleOptions: toggleOptions)
            : SignInButton(toggleOptions: toggleOptions),
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.deepPurple,
        ),
        if (authCubit.isAuthenticated())
          Column(
            children: [
              TextButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(60, 40)),
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamed('/leaderboard');
                  await Future.delayed(const Duration(seconds: 1));
                  toggleOptions();
                },
                child: const Text(
                  'LEADERBOARD',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.deepPurple,
              ),
            ],
          ),
        if (authCubit.isAuthenticated())
          Column(
            children: [
              TextButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(60, 40)),
                ),
                onPressed: () {
                  authCubit.manageAccount();
                },
                child: const Text(
                  'MANAGE ACCOUNT',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.deepPurple,
              ),
            ],
          ),
        if (authCubit.isAuthenticated())
          Column(
            children: [
              TextButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(60, 40)),
                ),
                onPressed: () {
                  authCubit.registerPasskey();
                },
                child: const Text(
                  'REGISTER PASSKEY',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.deepPurple,
              ),
            ],
          ),
        TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(const Size(60, 40)),
          ),
          onPressed: () {
            toggleOptions();
          },
          child: const Text(
            'HOME',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key, required this.toggleOptions});
  final VoidCallback toggleOptions;

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<RowndCubit>();

    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(60, 40)),
      ),
      onPressed: () {
        authCubit.signOut();
        toggleOptions();
      },
      child: const Text(
        'SIGN OUT',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key, required this.toggleOptions});

  final VoidCallback toggleOptions;

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<RowndCubit>();

    return BlocListener<RowndCubit, AuthState>(
      listener: (context, state) {
        if (authCubit.isAuthenticated()) {
          toggleOptions();
        }
      },
      child: TextButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(60, 40)),
        ),
        onPressed: () {
          authCubit.signIn();
        },
        child: const Text(
          'SIGN IN',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
