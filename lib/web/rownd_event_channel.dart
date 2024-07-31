import 'dart:convert';

import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/domain/app.dart';
import 'package:rownd_flutter_plugin/state/domain/auth.dart' as authState;
import 'package:rownd_flutter_plugin/state/domain/user.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

import 'stubs/js_stub.dart' if (dart.library.js) 'dart:js' as js;
import 'stubs/web_stub.dart' if (dart.library.js) 'package:web/web.dart' as web;

class WebState {
  WebState({this.user, this.app, this.auth});
  User? user;
  App? app;
  authState.Auth? auth;

  WebState.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    app = App.fromJson(json["app"]);
    auth = authState.Auth.fromJson(json['auth']);
  }
}

class RowndStateWebEventChannel {
  final GlobalStateNotifier _stateNotifier = GlobalStateNotifier();
  GlobalStateNotifier get stateNotifier => _stateNotifier;

  void invokeMethod(List<String> keys, [Map<String, Object>? data]) {
    var rowndMethod = js.context['rownd'];

    for (var i = 0; i < keys.length - 1; i++) {
      rowndMethod = rowndMethod[keys[i]];
    }

    rowndMethod.callMethod(
        keys.last, data == null ? null : [js.JsObject.jsify(data)]);
  }

  void configure(RowndConfig configure) {
    _addHubScript(configure.baseUrl);
    _setConfigValue('setAppKey', configure.appKey);
    _setConfigValue('setApiUrl', configure.apiUrl);
    _setStateListener();
  }

  void _addHubScript(String? baseUrl) {
    baseUrl = baseUrl ?? 'https://hub.rownd.io';
    final script = web.document.createElement('script');
    script.innerHTML = '''
      !function () {
      var e = window._rphConfig = window._rphConfig || [];
      let t = window.localStorage.getItem("rph_base_url_override") || "$baseUrl"; e.push(["setBaseUrl", t]);
      var r = document, s = r.createElement("script"), m = r.createElement("script"), a = r.getElementsByTagName("script")[0];
      s.type = "text/javascript", s.noModule = !0, s.async = !0, s.src = t + "/static/scripts/rph.js", a.parentNode.insertBefore(s, a);
      m.type = "module", m.async = !0, m.src = t + "/static/scripts/rph.mjs", a.parentNode.insertBefore(m, a);
    } ();
    ''';

    web.document?.head?.appendChild(script);
  }

  void _setStateListener() {
    void listener(String state) {
      _listener(state);
    }

    var jsFunction = js.allowInterop((data) {
      _listener(data);
    });

    if (js.context.hasProperty('_rphConfig')) {
      js.context['_rphConfig'].callMethod('push', [
        js.JsArray.from(['setStateStringListener', jsFunction])
      ]);
    }
  }

  void _listener(String data) {
    Map<String, dynamic> valueMap = jsonDecode(data);
    var webState = WebState.fromJson(valueMap);

    _stateNotifier.state = GlobalState(
        app: webState.app, auth: webState.auth, user: webState.user);
  }

  void _setConfigValue(String key, String? value) {
    if (value == null) {
      return;
    }

    if (js.context.hasProperty('_rphConfig')) {
      // Access the existing _rphConfig
      var rphConfig = js.context['_rphConfig'];
      // Push a new key-value pair
      rphConfig.callMethod('push', [
        js.JsArray.from([key, value])
      ]);
    }
  }
}
