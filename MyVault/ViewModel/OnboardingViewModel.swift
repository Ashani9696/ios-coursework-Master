//
//  OnboardingViewModel.swift
//  MyVault
//
//  Created by Mudara on 2023-09-23.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    @Published var items: [OnboardingModel] = [
        OnboardingModel(title: "Gain total control of your money", description: "Become your own money manager and make every cent count", image: "ic_onboard_01", color: "#F0B86E"),
        OnboardingModel(title: "Know where your money goes", description: "Track your transaction easily, with categories and financial report", image: "ic_onboard_02", color: "#A2678A"),
        OnboardingModel(title: "Planning ahead", description: "Setup your budget for each category so you in control", image: "ic_onboard_03", color: "#33BBC5")
    ]
}
