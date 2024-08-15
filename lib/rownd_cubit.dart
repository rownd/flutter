import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

enum AuthState { authenticated, unauthenticated, loading }

class RowndCubit extends Cubit<AuthState> {
  final RowndPlugin rowndPlugin;
  final GlobalStateNotifier rowndStateNotifier;
  Map<String, dynamic>? user;

  RowndCubit(this.rowndPlugin)
      : rowndStateNotifier = rowndPlugin.state(),
        super(AuthState.unauthenticated) {
    // Initialize the cubit by setting up a listener to the authentication state
    _initialize();
  }

  void _initialize() {
    rowndStateNotifier.addListener(() {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    if (rowndStateNotifier.state.auth?.isAuthenticated ?? false) {
      emit(AuthState.loading);

      await _getUserData();

      if (user != null) {
        emit(AuthState.authenticated);
      } else {
        emit(AuthState.unauthenticated);
      }
    } else {
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> signIn([RowndSignInOptions? options]) async {
    emit(AuthState.loading);
    rowndPlugin.requestSignIn(options);
  }

  Future<void> signOut() async {
    rowndPlugin.signOut();
    emit(AuthState.unauthenticated);
  }

  bool isAuthenticated() {
    return rowndStateNotifier.state.auth?.isAuthenticated ?? false;
  }

  Future<void> _getUserData() async {
    final userData = rowndStateNotifier.state.user?.data;
    if (userData!.isEmpty) {
      user = null;
      return;
    }

    user = {
      "firstName": userData['first_name'],
      "lastName": userData['last_name'],
      "email": userData['email'],
    };
  }

  void manageAccount() {
    rowndPlugin.manageAccount();
  }
}
