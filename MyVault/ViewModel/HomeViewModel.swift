//
//  HomeViewModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var showFilterTime = false
    @Published var showReportSelect = false
    @Published var showWalletFilter = false
    @Published var filterTime = 0
    @Published var filterWallet = 0
    @Published var reportType: Bool = false
    @State var filterTypes = ["Today", "Month", "Year"]
    @Published var jumpToReport: Bool = false
    @Published var isError = false
    @Published var isLoading = false
    var cancellables = Set<AnyCancellable>()
    
    @Published var walletResponse = WalletData(userId: "", isFiltered: false, incomeAmount: 0, expenseAmount: 0)
    @Published var transferListResponse = TransactionData(isFiltered: false, transactionList: [])
    
    func getUserBalance() {
            let headerParams = [
                "Authorization":
                    UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.ACCESS_TOKEN)
            ]
            let bodyParams = [
                "userId":
                    UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
                "filterType": "\(filterWallet)"
            ]
            NetworkManager.shared.request("wallet/getWalletDetails", method: .POST, body: bodyParams, headers: headerParams, response: WalletModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    withAnimation{
                        if response.status {
                            self.walletResponse = response.data!
                        } else {
                            self.isError = true
                        }
                    }
                })
                .store(in: &cancellables)
    }
    
    func getUserTransactions(){
        self.isLoading = true
            let headerParams = [
                "Authorization":
                    UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.ACCESS_TOKEN)
            ]
            let bodyParams = [
                "userId":
                    UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
                "filterType": "\(filterTime)"
            ]
            NetworkManager.shared.request("wallet/getTransactionList", method: .POST, body: bodyParams, headers: headerParams, response: TransactionListModel.self)
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
                            self.transferListResponse.transactionList.removeAll()
                            self.transferListResponse = response.data!
                        } else {
                            self.isError = true
                        }
                        self.isLoading = false
                    }
                })
                .store(in: &cancellables)
    }
}
