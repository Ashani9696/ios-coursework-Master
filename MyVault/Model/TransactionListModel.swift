//
//  TransactionListModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation

struct TransactionListModel: Codable {
    let status: Bool
    let data: TransactionData?
    let message: String?
}

struct TransactionData: Codable {
    let isFiltered: Bool
    var transactionList: [TransactionItem]
}

struct TransactionItem: Codable {
    let transactionId: String
    let transactionType: Int
    let transactionCategory: Int
    let transactionDate: Int
    let transactionAmount: Double
    let transactionRemark: String
    let transactionImg: String?
}
