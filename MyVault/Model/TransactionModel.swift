//
//  TransactionModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation

struct TransactionModel: Codable {
    let status: Bool
    let data: TransactionItem?
    let message: String?
}
