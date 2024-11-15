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
    @Published var errorMessage: String? = nil  // New property to store error messages
    @Published var isLoading: Bool = false
    @Published var jumpToMain: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    func validateReg() -> Bool {
        guard !self.regUsername.isEmpty else {
            self.errorMessage = "Username cannot be empty"
            self.isLoading = false
            return false
        }
        
        guard !self.regEmail.isEmpty else {
            self.errorMessage = "Email cannot be empty"
            self.isLoading = false
            return false
        }
        
        guard !self.regPassword.isEmpty else {
            self.errorMessage = "Password cannot be empty"
            self.isLoading = false
            return false
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: self.regEmail) else {
            self.errorMessage = "Invalid email format"
            self.isLoading = false
            return false
        }
        
        return true
    }
    
    func createUser() {
        self.isLoading = true
        self.errorMessage = nil  // Reset error message
        //if validateReg() {
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
                        self.errorMessage = "Registration failed: \(error.localizedDescription)"
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    self.isLoading = false
                    withAnimation {
                        if response.status {
                            self.isSuccess = true
                        } else {
                            self.isError = true
                            self.errorMessage = "Registration unsuccessful. Try again."
                        }
                    }
                })
                .store(in: &cancellables)
//        } else {
//            self.isError = true
//        }
    }
    
    func validateSign() -> Bool {
        guard !self.logEmail.isEmpty else {
            self.errorMessage = "Email cannot be empty"
            self.isLoading = false
            return false
        }
        
        guard !self.logPassword.isEmpty else {
            self.errorMessage = "Password cannot be empty"
            self.isLoading = false
            return false
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: self.logEmail) else {
            self.errorMessage = "Invalid email format"
            self.isLoading = false
            return false
        }
        
        return true
    }
    
    func loginUser() {
        self.isLoading = true
        self.errorMessage = nil  // Reset error message
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
                        self.errorMessage = "Login failed: \(error.localizedDescription)"
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    self.isLoading = false
                    withAnimation {
                        if response.status {
                            UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.IS_LOGGEDIN)
                            UserDefaultsManager.shared.setString(response.data?.user.userID ?? "", forKey: UserDefaultsManager.USER_ID)
                            UserDefaultsManager.shared.setString(response.data?.user.username ?? "", forKey: UserDefaultsManager.USERNAME)
                            UserDefaultsManager.shared.setString(response.data?.user.email ?? "", forKey: UserDefaultsManager.USER_EMAIL)
                            UserDefaultsManager.shared.setString("Bearer \(response.data?.accessToken ?? "")", forKey: UserDefaultsManager.ACCESS_TOKEN)
                            self.jumpToMain = true
                        } else {
                            self.isError = true
                            self.errorMessage = "Login unsuccessful. Try again."
                        }
                    }
                })
                .store(in: &cancellables)
        } else {
            self.isError = true
        }
    }
}
