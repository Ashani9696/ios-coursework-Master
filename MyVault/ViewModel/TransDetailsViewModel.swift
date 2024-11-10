//
//  TransDetailsViewModel.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation

class TransDetailsViewModel: ObservableObject {

    @Published var message: String = ""
    @Published var isSuccess: Bool = false
    @Published var showToolTip: Bool = false
}
