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
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)

        FlutterEventChannel(name: stateEventChannel, binaryMessenger: registrar.messenger())
            .setStreamHandler(StateStreamHandler())
    }

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if let launchUrl = launchOptions?[.url] as? URL {
            Rownd.handleSignInLink(url: launchUrl)
        }

        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return Rownd.handleSignInLink(url: url)
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        if userActivity.webpageURL != nil {
            return Rownd.handleSignInLink(url: userActivity.webpageURL)
        }
        return false
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "configure":
            if let args = call.arguments as? [String: Any],
               let appKey = args["appKey"] as? String {
                if let baseUrl = args["baseUrl"] as? String {
                    Rownd.config.baseUrl = baseUrl
                }

                if let apiUrl = args["apiUrl"] as? String {
                    Rownd.config.apiUrl = apiUrl
                }
                
                if let subdomainExtension = args["subdomainExtension"] as? String {
                    Rownd.config.subdomainExtension = subdomainExtension
                }
                Task {
                    await Rownd.configure(launchOptions: nil, appKey: appKey)
                }
            }
        case "requestSignIn":
            if let args = call.arguments as? [String: Any],
               let postSignInRedirect = args["postSignInRedirect"] as? String {
                Rownd.requestSignIn(RowndSignInOptions(postSignInRedirect: postSignInRedirect))
            } else {
                Rownd.requestSignIn()
            }
        case "signOut":
            Rownd.signOut()
        case "manageAccount":
            Rownd.manageAccount()
        case "passkeysRegister":
            Rownd.auth.passkeys.register()
        case "passkeysAuthenticate":
            Rownd.auth.passkeys.authenticate()
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getAccessToken":
            Task {
                if let accessToken = try? await Rownd.getAccessToken() {
                    result(accessToken)
                } else {
                    result(FlutterError(code: "NO_ACCESS_TOKEN", message: "No access token found", details: nil))
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
