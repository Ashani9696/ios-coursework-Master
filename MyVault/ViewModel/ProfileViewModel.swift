//
//  ProfileViewModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var showLogout = false
    @Published var showCurrencyList = false
    @Published var currencyType = "USD"
    @Published var isError: Bool = false
    @Published var isLoggedOut: Bool = false
    
    func userLogout(){
        UserDefaultsManager.shared.setBool(false, forKey: UserDefaultsManager.IS_LOGGEDIN)
        UserDefaultsManager.shared.setString("", forKey: UserDefaultsManager.USER_ID)
        UserDefaultsManager.shared.setString("", forKey: UserDefaultsManager.USERNAME)
        UserDefaultsManager.shared.setString("", forKey: UserDefaultsManager.USER_EMAIL)
        UserDefaultsManager.shared.setString("", forKey: UserDefaultsManager.ACCESS_TOKEN)
        self.isLoggedOut = true
    }
}
