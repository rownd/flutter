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
                if let baseUrl = args["baseUrl"] as? String {
                    Rownd.config.baseUrl = baseUrl
                }
                if let apiUrl = args["apiUrl"] as? String {
                    Rownd.config.apiUrl = apiUrl
                }
              Task {
                  await Rownd.configure(launchOptions: nil, appKey: appKey);
              }
          }
      case "requestSignIn":
          if let args = call.arguments as? Dictionary<String, Any> {
              var rowndSignInOptions = RowndSignInOptions()
              if let postSignInRedirect = args["postSignInRedirect"] as? String {
                  rowndSignInOptions.postSignInRedirect = postSignInRedirect
              }
              
              if let intentString = args["intent"] as? String {
                  if let intent = RowndSignInIntent(rawValue: intentString) {
                      rowndSignInOptions.intent = intent
                  } else {
                      print("Rownd plugin. An incorrect intent type was used: \(intentString)")
                  }
              }
              func requestSignInHub() -> Void {
                  DispatchQueue.main.async {
                      Rownd.requestSignIn(rowndSignInOptions)
                  }
              }
              
              if let method = args["method"] as? String {
                  switch method {
                  case "apple":
                      DispatchQueue.main.async {
                          Rownd.requestSignIn(with: RowndSignInHint.appleId, signInOptions: rowndSignInOptions)
                      }
                  case "google":
                      DispatchQueue.main.async {
                          Rownd.requestSignIn(with: RowndSignInHint.googleId, signInOptions: rowndSignInOptions)
                      }
                  case "guest":
                      DispatchQueue.main.async {
                          Rownd.requestSignIn(with: RowndSignInHint.guest, signInOptions: rowndSignInOptions)
                      }
                  case "passkey":
                      DispatchQueue.main.async {
                          Rownd.requestSignIn(with: RowndSignInHint.passkey, signInOptions: rowndSignInOptions)
                      }
                  default:
                      requestSignInHub()
                  }
              } else {
                  requestSignInHub()
              }
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
