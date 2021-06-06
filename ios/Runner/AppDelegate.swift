import UIKit
import Flutter
import GoogleMaps
import Firebase;

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDi9YjomCjLxPEfZiOHzitw8HyGyDHFL40")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
