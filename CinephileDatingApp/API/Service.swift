//
//  Service.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.04.2024.
//

import UIKit
import Firebase

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> ()) {
        Constraints.Firebase.COLLECTION_USERS.document(uid).getDocument() { (snapshot, error) in
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping ([User]) -> ()) {
        var users = [User]()
        
        Constraints.Firebase.COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach { document in
                let dict = document.data()
                let user = User(dict: dict)
                
                users.append(user)
                
                if users.count == snapshot?.documents.count {
                    completion(users)
                }
            }
        }
    }
    
    static func saveUserData(user: User, completion: @escaping (Error?) -> ()) {
        let data = ["uid": user.uid,
                    "name": user.name,
                    "age": user.age,
                    "bio": user.bio,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge,
                    "imageURLs": user.profileImageURLs] as [String: Any]
        
        Constraints.Firebase.COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let shouldLike = isLike ? 1 : 0
        
        Constraints.Firebase.COLLECTION_SWIPES.document(uid).getDocument() { (snapshot, error) in
            let data = [user.uid : isLike]
            
            if snapshot?.exists == true {
                Constraints.Firebase.COLLECTION_SWIPES.document(uid).updateData(data)
            } else {
                Constraints.Firebase.COLLECTION_SWIPES.document(uid).setData(data)
            }
        }
    }
 
    static func uploadImage(image: UIImage, completion: @escaping (String) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Error uploading image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL() { (url, error) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
