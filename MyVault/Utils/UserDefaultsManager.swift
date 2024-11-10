//
//  UserDefaultsManager.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    static let IS_LOGGEDIN = "IS_LOGGEDIN"
    static let IS_DONE_ONBOARD = "IS_DONE_ONBOARD"
    static let IS_PIN_SETTED = "IS_PIN_SETTED"
    static let USER_ID = "USER_ID"
    static let USERNAME = "USERNAME"
    static let USER_EMAIL = "USER_EMAIL"
    static let ACCESS_TOKEN = "ACCESS_TOKEN"
    static let ACCESS_PIN = "ACCESS_PIN"

    func setString(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getString(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func setBool(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getBool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    func setInt(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getInt(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    func removeValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func clearAllUserDefaults() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
