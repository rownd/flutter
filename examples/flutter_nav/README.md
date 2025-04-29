# RowndCubit and BlocProvider Integration

This document explains how the `RowndCubit` is integrated within the Flutter application using `BlocProvider` and how it is utilized to manage authentication states.

## Overview

In this application, the `RowndCubit` manages the authentication flow using the Rownd plugin. The `BlocProvider` ensures that the `RowndCubit` is accessible across the entire application, allowing different parts of the app to respond to authentication state changes.

### Key Components

- `RowndCubit`: Manages the authentication logic, including sign-in, sign-out, and user state retrieval.
- `BlocProvider`: Provides the `RowndCubit` to the widget tree, ensuring that it can be accessed and updated throughout the app.
- `BlocBuilder`: Listens for state changes from the `RowndCubit` and rebuilds the UI based on the current authentication state.

## Code Example

### 1. Initializing the `RowndPlugin`
```dart
class _MyAppState extends State<MyApp> {
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();
    rowndPlugin.configure(RowndConfig(appKey: 'YOUR_APP_KEY'));
  }
}
```

Here, the `RowndPlugin` is initialized in the `initState` method and configured with your app key. This setup is required for the Rownd authentication plugin to function correctly.

### 2. Providing the `RowndCubit`
```dart
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => RowndCubit(rowndPlugin),
    child: MaterialApp(
      title: 'Example App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: BlocBuilder<RowndCubit, AuthState>(
        builder: (context, state) {
          if (state == AuthState.authenticated) {
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => const MyHomePage(),
      },
    ),
  );
}
```
In this example:

- The `BlocProvider` wraps the `MaterialApp`, providing the `RowndCubit` to the entire widget tree.
- `BlocBuilder` listens for changes in the authentication state and determines whether to show the `LoginPage` or `MyHomePage`.

### 3. Utilizing the `RowndCubit` in Different Pages

#### Login Page
```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = context.watch<RowndCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My example app'),
      ),
      body: Column(
        children: [
          const Center(child: Text('Welcome to my example app!')),
          ElevatedButton(
            onPressed: () async {
              authCubit.signIn();
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
```

In the `LoginPage`, the `RowndCubit` is accessed using `context.watch<RowndCubit>()`. This allows the button to trigger the `signIn` method, initiating the authentication process.

#### Home Page

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var authCubit = context.watch<RowndCubit>();
    var user = User.fromJson(authCubit.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My example app'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Column(
        children: [
          Center(child: Text('Welcome to my home page, ${user.firstName}!')),
          ElevatedButton(
            onPressed: () async {
              authCubit.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text("Sign out"),
          ),
          ElevatedButton(
            onPressed: () async {
              authCubit.manageAccount();
            },
            child: const Text("Manage Account"),
          ),
        ],
      ),
    );
  }
}
```

In the `MyHomePage`, the `RowndCubit` is also accessed to retrieve the current user's details and manage account-related actions. The `signOut` method logs the user out and redirects them to the login page.

### Conclusion

By integrating `RowndCubit` with `BlocProvider`, you can effectively manage the authentication state across your Flutter application. This setup ensures that the UI remains responsive to changes in authentication status, providing a seamless user experience.

