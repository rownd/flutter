import UIKit
import Flutter
import Rownd

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Task {
      // await Rownd.configure(launchOptions: launchOptions, appKey:  "b60bc454-c45f-47a2-8f8a-12b2062f5a77")
    }
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
