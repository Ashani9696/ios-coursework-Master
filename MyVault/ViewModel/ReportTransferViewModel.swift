//
//  ReportTransferViewModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class ReportTransferViewModel: ObservableObject {
    private var imageUrl: String = ""
    @Published var transDesc: String = ""
    @Published var transAmount: String = ""
    @Published var showCategories: Bool = false
    @Published var isPickerPresented: Bool = false
    @Published var selectedImage: UIImage? = nil
    @Published var isError: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isLoading = false
    @Published var reportType: Bool
    @Published var selectedCategory: Int = 0
    @Published var expenseCategories = ["Food and Dining", "Shopping", "Housing", "Utilities", "Healthcare", "Travel", "Subscriptions", "Other"]
    @Published var incomeCategories = ["Salary", "Bonuses", "Investment", "Other"]
    var cancellables = Set<AnyCancellable>()
    
    init(reportType: Bool) {
        self.reportType = reportType
    }
    
    func uploadToStorage(selectedImage: UIImage){
        ImageUploadUtils.uploadImage(selectedImage: selectedImage) { downloadURL in
            if let downloadURL = downloadURL {
                self.imageUrl = downloadURL.absoluteString
                self.reportTransfer()
                print("Download URL: \(downloadURL)")
            } else {
                self.isLoading = false
                print("Error uploading image or getting download URL.")
            }
        }
    }
    
    func validateReport() -> Bool {
        self.isLoading = true
        if self.transAmount.isEmpty {
            self.isLoading = false
            return false
        }
        
        if self.transDesc.isEmpty {
            self.isLoading = false
            return false
        }
        
        return true
    }
    
    func reportTransfer() {
        let headerParams = [
            "Authorization":
                UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.ACCESS_TOKEN)
        ]
        let bodyParams: [String: Any]
        if (!imageUrl.isEmpty) {
            bodyParams = [
                "userId": UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
                "transactionList": [
                    [
                        "transactionType": reportType ? 2 : 1,
                        "transactionCategory": selectedCategory,
                        "transactionAmount": Int(transAmount)!,
                        "transactionRemark": transDesc,
                        "transactionImg": imageUrl
                    ]
                ]
            ]
        } else {
            bodyParams = [
                "userId": UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
                "transactionList": [
                    [
                        "transactionType": reportType ? 2 : 1,
                        "transactionCategory": selectedCategory,
                        "transactionAmount": Int(transAmount)!,
                        "transactionRemark": transDesc
                    ]
                ]
            ]
        }
        NetworkManager.shared.request("wallet/add", method: .POST, body: bodyParams, headers: headerParams, response: TransactionModel.self)
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
                        self.isSuccess.toggle()
                    } else {
                        self.isError = true
                    }
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)
    }
}

