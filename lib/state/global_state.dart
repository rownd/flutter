import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'domain/app.dart';
import 'domain/auth.dart';
import 'domain/user.dart';

part 'global_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GlobalState {
  GlobalState({
    this.app,
    this.auth,
    this.user,
  });

  @JsonKey(name: 'appConfig')
  App? app;
  Auth? auth;
  User? user;

  factory GlobalState.fromJson(Map<String, dynamic> json) =>
      _$GlobalStateFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalStateToJson(this);
}

class GlobalStateNotifier extends ChangeNotifier {
  GlobalStateNotifier({GlobalState? state}) : _state = state ?? GlobalState();
  bool isDisposed = false;

  GlobalState _state;

  GlobalState get state => _state;

  set state(GlobalState state) {
    _state = state;

    if (isDisposed) {
      return;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
