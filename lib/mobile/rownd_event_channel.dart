import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class RowndStateMobileEventChannel {
  // Global State Event Channel
  final _rowndStateChannel = const EventChannel('rownd_channel_events/state');
  Stream<void>? _rowndStateStream;
  final GlobalStateNotifier _stateNotifier = GlobalStateNotifier();

  GlobalStateNotifier get stateNotifier => _stateNotifier;

  // RowndStateEventChannel() {
  //   _rowndStateStream = listen();
  // }

  StreamSubscription<void> listen() {
    print("setting up state event channel listener");
    Stream<void> stateStream = _rowndStateStream =
        _rowndStateChannel.receiveBroadcastStream().distinct();
    // .map((dynamic event) => _handleStateChanges(event as String))

    return stateStream
        .listen((dynamic event) => _handleStateChanges(event as String));
  }

  void _handleStateChanges(String evt) {
    print("Received event: $evt");
    Map<String, dynamic> userMap = jsonDecode(evt);
    var state = GlobalState.fromJson(userMap);
    inspect(state);
    _stateNotifier.state = state;
  }
}
