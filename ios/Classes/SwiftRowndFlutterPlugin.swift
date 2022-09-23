import Flutter
import UIKit
import Rownd
import Combine
import SwiftUI

public class SwiftRowndFlutterPlugin: NSObject, FlutterPlugin {

    private static let methodEventChannel = "rownd_flutter_plugin"
    private static let stateEventChannel = "rownd_channel_events/state"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: methodEventChannel, binaryMessenger: registrar.messenger())
    let instance = SwiftRowndFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

      FlutterEventChannel(name: stateEventChannel, binaryMessenger: registrar.messenger())
          .setStreamHandler(StateStreamHandler())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "configure":
          if let args = call.arguments as? Dictionary<String, Any>,
             let appKey = args["appKey"] as? String {
              Task {
                  await Rownd.configure(launchOptions: nil, appKey: appKey);
              }
          }
      case "requestSignIn":
          if let args = call.arguments as? Dictionary<String, Any>,
             let postSignInRedirect = args["postSignInRedirect"] as? String {
              Rownd.requestSignIn(RowndSignInOptions(postSignInRedirect: postSignInRedirect))
          } else {
              Rownd.requestSignIn()
          }
      case "signOut":
          Rownd.signOut()
      case "manageAccount":
          Rownd.manageAccount()
      case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
