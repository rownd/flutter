import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

enum AuthState { authenticated, unauthenticated, loading }

class RowndAuthCubit extends Cubit<AuthState> {
  final RowndPlugin rowndPlugin;
  final GlobalStateNotifier rowndStateNotifier;

  RowndAuthCubit(this.rowndPlugin)
      : rowndStateNotifier = rowndPlugin.state(), // Assign directly in initializer list
        super(AuthState.unauthenticated) {
    // Initialize the cubit by setting up a listener to the authentication state
    _initialize();
  }

  void _initialize() {
    rowndStateNotifier.addListener(() {
      checkAuthentication();
    });
  }

  void checkAuthentication() {
    if (rowndStateNotifier.state.auth?.isAuthenticated ?? false) {
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
}
