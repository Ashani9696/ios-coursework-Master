//
//  TransfersViewModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import SwiftUI
import Combine

class TransfersViewModel: ObservableObject {
    @Published var showFilterTime = false
    @Published var showFilterType = false
    @Published var filterTime = 0
    @Published var filterType = 0
    @State var filterTypes = ["Today", "Month", "Year"]
    @Published var isError = false
    @Published var isLoading = false
    var cancellables = Set<AnyCancellable>()
    
    @Published var transferListResponse = TransactionData(isFiltered: false, transactionList: [])
    
    func getUserTransactions(){
        self.isLoading = true
        let headerParams = [
            "Authorization":
                UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.ACCESS_TOKEN)
        ]
        let bodyParams = [
            "userId":
                UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
            "filterType": "\(filterTime)",
            "transType": "\(filterType)"
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
