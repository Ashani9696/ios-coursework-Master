//
//  WalletDetailsModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation

struct WalletModel: Codable {
    let status: Bool
    let data: WalletData?
    let message: String?
}

struct WalletData: Codable {
    let userId: String
    let isFiltered: Bool
    let incomeAmount: Double
    let expenseAmount: Double
}
