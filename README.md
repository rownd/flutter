# Rownd bindings for Flutter

Easily add Rownd to your Flutter app.

## Getting Started

This SDK leverages Rownd's native iOS and Android SDKs to provide a simple interface for Flutter developers to add Rownd to their apps.

### Install
Begin by depending on `rownd_flutter_plugin` in your `pubspec.yaml`:

```yaml
name: my_app

...

dependencies:
    rownd_flutter_plugin: ^1.0.0
```

If you don't have one already, be sure to obtain an app key from the [Rownd dashboard](https://app.rownd.io) for use in the next step.

### Configure

Next, instantiate the Rownd plugin and call `Rownd.configure(YOUR_APP_KEY)` within your application wherever you do most of your app's initialization.

Here's an example:

```dart
import 'package:flutter/services.dart';

import 'package:rownd_flutter_plugin/rownd.dart';

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
  final _rownd = RowndPlugin();

  @override
  void initState() {
    super.initState();

    _rownd.configure("REPLACE_WITH_YOUR_APP_KEY");
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
  final _rownd = RowndPlugin();

  @override
  void initState() {
    super.initState();

    _rownd.configure("REPLACE_WITH_YOUR_APP_KEY");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _rownd.state(),
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
                      if (rownd.state.auth?.isAuthenticated ?? false) {
                        _rownd.signOut();
                      } else {
                        RowndSignInOptions signInOpts = RowndSignInOptions();
                        signInOpts.postSignInRedirect =
                            "https://deeplink.myapp.com";
                        _rownd.requestSignIn(signInOpts);
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

## API

### `configure(String appKey)`

Configures the Rownd plugin with your app key. This must be called before any other methods.

### `requestSignIn(RowndSignInOptions options)`

Requests that the user sign in. The `options` parameter is optional and can be used to customize the sign-in process.

#### `RowndSignInOptions`

| Property | Type | Description |
| --- | --- | --- |
| `postSignInRedirect` | `String` | The URL to redirect to after the user has signed in. This can be used for deep-linking within the app or to ensure that the user is redirected back into the app after completing a sign-in from email or text message. |

### `signOut()`

Signs the user out.

### `state()`

Returns a `GlobalStateNotifier` object that can be used to listen for changes to the Rownd state.

### `GlobalStateNotifier`

The `GlobalStateNotifier` object is a `ChangeNotifier` that notifies its listeners whenever the Rownd state changes. It provides the following properties:

| Property | Type | Description |
| --- | --- | --- |
| `auth` | `RowndAuthState` | The current user's authentication state. |
| `user` | `RowndUser` | The current user's profile. |

