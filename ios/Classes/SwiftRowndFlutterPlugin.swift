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
            handleConfigure(call: call, result: result)
        case "requestSignIn":
            handleRequestSignIn(call: call, result: result)
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
            handleGetAccessToken(result: result)
        case "user.get":
            handleUserGet(call: call, result: result)
        case "user.getValue":
            handleUserGetValue(call: call, result: result)
        case "user.set":
            handleUserSet(call: call, result: result)
        case "user.setValue":
            handleUserSetValue(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleConfigure(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
    }

    private func handleRequestSignIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any],
           let postSignInRedirect = args["postSignInRedirect"] as? String {
            Rownd.requestSignIn(RowndSignInOptions(postSignInRedirect: postSignInRedirect))
        } else {
            Rownd.requestSignIn()
        }
    }

    private func handleGetAccessToken(result: @escaping FlutterResult) {
        Task {
            do {
                if let accessToken = try await Rownd.getAccessToken(throwIfMissing: true) {
                    result(accessToken)
                } else {
                    result(FlutterError(code: "NO_ACCESS_TOKEN", message: "No access token found", details: nil))
                }
            } catch {
                result(FlutterError(code: "ERROR_GETTING_ACCESS_TOKEN", message: error.localizedDescription, details: nil))
            }
        }
    }

    private func handleUserGet(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let user = Rownd.user.get()
            let userObj: [String: Any?] = [
                "data": user.data.mapValues { $0.value },
                "meta": user.meta?.mapValues { $0.value },
                "state": user.state.rawValue,
                "auth_level": user.authLevel.rawValue
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: userObj, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                    result(jsonString)
            } else {
                result(FlutterError(code: "INVALID_DATA", message: "Failed to convert user data to JSON string", details: nil))
            }
        } catch {
            result(FlutterError(code: "ERROR_ENCODING_USER_DATA", message: error.localizedDescription, details: nil))
        }
    }

    private func handleUserGetValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any],
           let key = args["key"] as? String {
            result(Rownd.user.get(field: key))
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
    }

    private func handleUserSet(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any] {
            let jsonData = try? JSONSerialization.data(withJSONObject: args)
            if let jsonData = jsonData {
                let decoder = JSONDecoder()
                if let userDict = try? decoder.decode([String: AnyCodable].self, from: jsonData) {
                    Rownd.user.set(data: userDict)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Failed to decode arguments", details: nil))
                }
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Failed to serialize arguments", details: nil))
            }
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments are not a valid dictionary", details: nil))
        }
    }

    private func handleUserSetValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any],
           let key = args["key"] as? String,
           let value = args["value"] as? Any {
            Rownd.user.set(field: key, value: AnyCodable(value))
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
    }
}
