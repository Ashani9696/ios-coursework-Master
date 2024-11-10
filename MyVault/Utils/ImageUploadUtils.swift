//
//  ImageUploadUtils.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import Firebase
import FirebaseStorage
import UIKit

class ImageUploadUtils {
    
    static func uploadImage(selectedImage: UIImage, completion: @escaping (URL?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")

        if let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
            let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
                guard error == nil else {
                    print("Error uploading image: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }

                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Error getting download URL: \(error?.localizedDescription ?? "")")
                        completion(nil)
                        return
                    }

                    print("Image uploaded successfully")
                    completion(downloadURL)
                }
            }
        }
    }
}
