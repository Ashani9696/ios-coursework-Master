//
//  AppLockViewModel.swift
//  MyVault
//
//  Created by Mudara on 2023-09-24.
//

import Foundation
import SwiftUI

class AppLockViewModel: ObservableObject {
    private var isSetPassword: Bool
    private var retryPin: Bool = false
    @Published var setupPIN = ""
    @Published var enteredPIN = ""
    @Published var pinTitle = ""
    @Published var error: Bool = false
    @Published var isSuccess: Bool = false
    @Published var jumpToMain = false
    
    init(isSetPassword: Bool) {
        self.isSetPassword = isSetPassword
        self.pinTitle = isSetPassword ? "Let’s setup your PIN" : "Please enter your PIN"
    }
    
    func verifyPIN() {
        if isSetPassword {
            if !retryPin {
                withAnimation{
                    self.pinTitle = "Ok. Re-type your PIN again."
                }
                self.setupPIN = self.enteredPIN
                self.enteredPIN = ""
                self.retryPin = true
            } else {
                if enteredPIN == setupPIN {
                    UserDefaultsManager.shared.setString(setupPIN, forKey: UserDefaultsManager.ACCESS_PIN)
                    self.isSuccess = true
                } else {
                    self.error.toggle()
                    self.retryPin = false
                    self.setupPIN = ""
                    self.pinTitle = "Let’s setup your PIN"
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                        self.enteredPIN = ""
                        self.error.toggle()
                    }
                }
            }
        } else {
            if enteredPIN == UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.ACCESS_PIN) as! String {
                withAnimation{
                    self.jumpToMain = true
                }
            } else {
                self.error.toggle()
                self.pinTitle = "PIN code dosen’t match"
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    self.enteredPIN = ""
                    self.error.toggle()
                }
            }
        }
    }
}

