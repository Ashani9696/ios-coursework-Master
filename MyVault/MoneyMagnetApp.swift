//
//  MyVaultApp.swift
//  MyVault
//
//  Created by Mudara on 2023-09-23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MyVaultApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            if UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_LOGGEDIN) {
                LockScreenView(isSetPassword: false)
            } else {
                if UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_DONE_ONBOARD) {
                    AuthenticationView()
                } else {
                    OnboardingView()
                }
            }
        }
    }
}
