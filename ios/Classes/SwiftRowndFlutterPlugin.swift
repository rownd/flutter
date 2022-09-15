import Flutter
import UIKit
import Rownd

public class SwiftRowndFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "rownd_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftRowndFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "requestSignIn":
          if let args = call.arguments as? Dictionary<String, Any>,
             let postSignInRedirect = args["postSignInRedirect"] as? String {
              Rownd.requestSignIn(RowndSignInOptions(postSignInRedirect: postSignInRedirect))
          } else {
              Rownd.requestSignIn()
          }
      case "signOut":
          Rownd.signOut()
      case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
