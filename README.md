# Rownd bindings for Flutter

Easily add Rownd to your Flutter app.

## Getting Started

This SDK leverages Rownd's native iOS and Android SDKs to provide a simple interface for Flutter developers to add Rownd to their apps.

### Install
Begin by depending on `rownd_flutter_plugin` and `provider` in your `pubspec.yaml`:

```yaml
name: my_app

...

dependencies:
    rownd_flutter_plugin: ^3.1.0
    provider: ^6.1.2
```

If you don't have one already, be sure to obtain an app key from the [Rownd dashboard](https://app.rownd.io) for use in the next step.

### Configure

Next, instantiate the Rownd plugin and call `rowndPlugin.configure(YOUR_APP_KEY)` within your application wherever you do most of your app's initialization.

Here's an example:

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();

    rowndPlugin.configure(RowndConfig(
        appKey: 'YOUR_APP_KEY'));
  }
}
```

## Usage

Now you're ready to use Rownd in your app. The plugin provides a simple interface for checking the current user's authentication status, signing in and out, and getting the current user's profile.

A basic sign-in example might look like this:

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();

    rowndPlugin.configure(RowndConfig(
        appKey: 'YOUR_APP_KEY'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _rownd.state()),
          Provider(create: (context) => rowndPlugin)
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('My example app'),
            ),
            body: Column(children: [
              Center(child: Text('Welcome to my example app!')),
              Consumer<GlobalStateNotifier>(
                builder: (_, rownd, __) => ElevatedButton(
                    onPressed: () {
                      var rowndPlugin = Provider.of<RowndPlugin>(context, listen: false);
                      if (rownd.state.auth?.isAuthenticated ?? false) {
                        rowndPlugin.signOut();
                      } else {
                        RowndSignInOptions signInOpts = RowndSignInOptions();
                        signInOpts.postSignInRedirect =
                            "https://deeplink.myapp.com";
                        rowndPlugin.requestSignIn(signInOpts);
                      }
                    },
                    child: Text((rownd.state.auth?.isAuthenticated ?? false)
                        ? 'Sign out'
                        : 'Sign in')),
              ),
            ]),
          ),
        ));
  }
}

```

Let's review what's happening here:

First, we configure Rownd with our app key as before. Then, when building our UI structure, we wrap the entire app in a `ChangeNotifierProvider` that provides the `GlobalStateNotifier` object to all of our widgets. This object is a `ChangeNotifier` that notifies its listeners whenever the Rownd state changes. We can use this object to listen for changes to the user's authentication status and update our UI accordingly.

When we need access to the Rownd state, we can use the `Consumer` widget to listen for changes to the `GlobalStateNotifier` object. The `Consumer` widget will rebuild its child whenever the `GlobalStateNotifier` object notifies its listeners. In this example, we use the `Consumer` widget to build a button that will sign the user in or out depending on their current authentication status.

## Platform-specific configuration

There are a couple of configuration settings that must be applied to the platform-specific code for your app in order for Rownd to work properly.

### Android

1) Set your app's `targetSdkVersion` to 32 or higher in your app's `build.gradle` file.

2) Set your app's `minSdkVersion` to 26 or higher in your app's `build.gradle` file. Rownd currently does not support an API version lower than 26.

3) Ensure any Android activities (like `MainActivity`) subclass `FlutterFragmentActivity` instead of `FlutterActivity`. If you're using the default `MainActivity` generated by Flutter, you can simply change the superclass to `FlutterFragmentActivity` like this:

```kotlin
class MainActivity: FlutterFragmentActivity() {}
```

4) Check and update your ProGuard config using [the rules from our Android SDK](https://github.com/rownd/android/blob/main/README.md#proguard-config).

## API

### `configure(RowndConfig({ appKey: String }))`

Configures the Rownd plugin with your app key. This must be called before any other methods.

### `requestSignIn(RowndSignInOptions options)`

Requests that the user sign in. The `options` parameter is optional and can be used to customize the sign-in process.

#### `RowndSignInOptions`

| Property | Type | Description |
| --- | --- | --- |
| `postSignInRedirect` | `String` | The URL to redirect to after the user has signed in. This can be used for deep-linking within the app or to ensure that the user is redirected back into the app after completing a sign-in from email or text message. |

### `signOut()`

Signs the user out.

### `manageAccount()`

Displays the current user's profile information, allowing them to update it.

### `user.get()`
Returns the current user's profile information as a `User` object.

### `user.getValue(String key)`
Returns the value associated with the specified key for the current user.

### `user.set(User user)`
Sets the current user's profile information to the specified `User` object.

### `user.setValue(String key, dynamic value)`
Sets the value associated with the specified key for the current user.

### `state()`

Returns a `GlobalStateNotifier` object that can be used to listen for changes to the Rownd state.

### `GlobalStateNotifier`

The `GlobalStateNotifier` object is a `ChangeNotifier` that notifies its listeners whenever the Rownd state changes. It provides the following properties:

| Property | Type | Description |
| --- | --- | --- |
| `auth` | `RowndAuthState` | The current user's authentication state. |
| `user` | `RowndUser` | The current user's profile. |

<br>
<br>

# RowndCubit and BlocProvider Integration

By integrating `RowndCubit` with `BlocProvider`, you can effectively manage the authentication state across your Flutter application. This setup ensures that the UI remains responsive to changes in authentication status, providing a seamless user experience.

Initialize the `RowndPlugin` in the `initState` method and configured with your app key. This setup is required for the Rownd authentication plugin to function correctly.

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

Use a `BlocProvider` that wraps around the `MaterialApp`, providing the `RowndCubit` to the entire widget tree. `BlocBuilder` listens for changes in the authentication state and determines whether to show the `LoginPage` or `MyHomePage`.

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

## Usage

In the `LoginPage`, the `RowndCubit` is accessed using `context.watch<RowndCubit>()`. This allows the button to trigger the `signIn` method, initiating the authentication process.

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

## Pre-configured RowndCubit API

`signIn([RowndSignInOptions? options])`\
Requests that the user sign in. The options parameter is optional and can be used to customize the sign-in process.

`signOut()`\
Signs the use out.

`isAuthenticated()`\
Returns a boolean if the user is signed in or out.

`manageAccount()`\
Displays the current user's profile information, allowing them to update it.

`user`\
Returns JSON object of the authenticated user's ID, first name, last name, and email.
