//
//  ImagePickerUtils.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import Foundation
import YPImagePicker
import SwiftUI
import UIKit

struct ImagePickerUtils: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> YPImagePicker {
        let picker = YPImagePicker()
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.selectedImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {
        
    }
}
