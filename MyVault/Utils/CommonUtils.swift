//
//  CommonUtils.swift
//  MyVault
//
//  Created by CodeLabs on 2023-10-02.
//

import Foundation
import SwiftUI
import UIKit

class CommonUtils {
    
    static func getExpenseTransferCategory(input: Int) -> String {
        switch input {
        case 0:
            return "Food and Dining"
        case 1:
            return "Shopping"
        case 2:
            return "Housing"
        case 3:
            return "Utilities"
        case 4:
            return "Healthcare"
        case 5:
            return "Travel"
        case 6:
            return "Subscriptions"
        case 7:
            return "Other"
        default:
            return "Other"
        }
    }
    
    static func getIncomeTransferCategory(input: Int) -> String {
        switch input {
        case 0:
            return "Salary"
        case 1:
            return "Bonuses"
        case 2:
            return "Investment"
        case 3:
            return "Other"
        default:
            return "Other"
        }
    }
    
    static func getExpenseIcon(input: Int) -> String {
        switch input {
        case 0:
            return "ic_food"
        case 1:
            return "ic_shop"
        case 2:
            return "ic_housing"
        case 3:
            return "ic_utilities"
        case 4:
            return "ic_health"
        case 5:
            return "ic_travel"
        case 6:
            return "ic_subscriptions"
        case 7:
            return "ic_other_minus"
        default:
            return "ic_other_minus"
        }
    }
    
    static func getIncomeIcon(input: Int) -> String {
        switch input {
        case 0:
            return "ic_salary"
        case 1:
            return "ic_bonus"
        case 2:
            return "ic_investment"
        case 3:
            return "ic_other_plus"
        default:
            return "ic_other_plus"
        }
    }
    
    static func formatTimestamp(_ timestamp: TimeInterval) -> String {
        let currentDate = Date()
        let inputDate = Date(timeIntervalSince1970: timestamp / 1000)
        
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDate(inputDate, inSameDayAs: currentDate) {
            dateFormatter.dateFormat = "hh:mm a"
        } else {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        }
        
        return dateFormatter.string(from: inputDate)
    }
    
    static func saveImageToAlbum(imageURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let imageURL = URL(string: imageURL) else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                completion(.success(image))
            } else {
                let unknownError = NSError(domain: "ImageDownloader", code: 0, userInfo: nil)
                completion(.failure(unknownError))
            }
        }
        task.resume()
    }
}
