import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

enum AuthState { authenticated, unauthenticated, loading }

class RowndAuthCubit extends Cubit<AuthState> {
  final RowndPlugin rowndPlugin;
  final GlobalStateNotifier rowndStateNotifier;
  Map<String, dynamic>? user;

  RowndAuthCubit(this.rowndPlugin)
      : rowndStateNotifier = rowndPlugin.state(),
        super(AuthState.unauthenticated) {
    // Initialize the cubit by setting up a listener to the authentication state
    _initialize();
  }

  void _initialize() {
    rowndStateNotifier.addListener(() {
      checkAuthentication();
    });
  }

  Future<void> checkAuthentication() async {
    if (rowndStateNotifier.state.auth?.isAuthenticated ?? false) {
      emit(AuthState.loading);
      await Future.delayed(const Duration(seconds: 1));

      user = getUserData();
      emit(AuthState.authenticated);
    } else {
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> signIn() async {
    emit(AuthState.loading);
    RowndSignInOptions signInOpts = RowndSignInOptions();
    rowndPlugin.requestSignIn(signInOpts);
  }

  Future<void> signOut() async {
    rowndPlugin.signOut();
  }

  bool isAuthenticated() {
    return rowndStateNotifier.state.auth?.isAuthenticated ?? false;
  }

  Map<String, dynamic> getUserData() {
    var user = rowndStateNotifier.state.user?.data;

    final firstName = user?['first_name'];
    final lastName = user?['last_name'];
    final email = user?['email'];

    return {"first_name": firstName, "last_name": lastName, "email": email};
  }
}
