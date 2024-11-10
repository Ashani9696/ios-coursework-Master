//
//  AuthenticationViewModel.swift
//  MyVault
//
//  Created by Mudara on 2023-09-24.
//

import Foundation
import Combine
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    
    @Published var isToggledLog: Bool = false
    @Published var isSuccess: Bool = false
    @Published var regUsername: String = ""
    @Published var regEmail: String = ""
    @Published var regPassword: String = ""
    @Published var logEmail: String = ""
    @Published var logPassword: String = ""
    @Published var isError: Bool = false
    @Published var isLoading: Bool = false
    @Published var jumpToMain: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    func validateReg() -> Bool {
        if self.regUsername.isEmpty {
            self.isLoading = false
            return false
        }
        
        if self.regEmail.isEmpty {
            self.isLoading = false
            return false
        }
        
        if self.regPassword.isEmpty {
            self.isLoading = false
            return false
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: self.regEmail) {
            self.isLoading = false
            return false
        }
        
        return true
    }
    
    func createUser() {
        self.isLoading = true
        if validateReg() {
            let bodyParams = [
                "username": regUsername,
                "email": regEmail,
                "password": regPassword
            ]
            NetworkManager.shared.request("user/register", method: .POST, body: bodyParams, response: LoginUserModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    if response.status {
                        withAnimation{
                            self.isSuccess.toggle()
                        }
                    } else {
                        self.isError = true
                    }
                    self.isLoading = false
                })
                .store(in: &cancellables)
        } else {
            self.isError = true
        }
    }
    
    func validateSign() -> Bool {
        if self.logEmail.isEmpty {
            self.isLoading = false
            return false
        }
        
        if self.logPassword.isEmpty {
            self.isLoading = false
            return false
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: self.logEmail) {
            self.isLoading = false
            return false
        }
        
        return true
    }
    
    func loginUser() {
        self.isLoading = true
        if validateSign() {
            let bodyParams = [
                "email": logEmail,
                "password": logPassword
            ]
            NetworkManager.shared.request("user/login", method: .POST, body: bodyParams, response: UserModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    withAnimation{
                        if response.status {
                            UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.IS_LOGGEDIN)
                            UserDefaultsManager.shared.setString(response.data?.user.userID ?? "", forKey: UserDefaultsManager.USER_ID)
                            UserDefaultsManager.shared.setString(response.data?.user.username ?? "", forKey: UserDefaultsManager.USERNAME)
                            UserDefaultsManager.shared.setString(response.data?.user.email ?? "", forKey: UserDefaultsManager.USER_EMAIL)
                            UserDefaultsManager.shared.setString("Bearer \(response.data?.accessToken ?? "")", forKey: UserDefaultsManager.ACCESS_TOKEN)
                            withAnimation{
                                self.jumpToMain.toggle()
                            }
                        } else {
                            self.isError = true
                        }
                        self.isLoading = false
                    }
                })
                .store(in: &cancellables)
        } else {
            self.isError = true
        }
    }
}
