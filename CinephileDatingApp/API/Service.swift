//
//  Service.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.04.2024.
//

import UIKit
import Firebase

struct Service {
    
    // MARK: - Get Data
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> ()) {
        Constants.Firebase.COLLECTION_USERS.document(uid).getDocument() { (snapshot, error) in
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    static func fetchUsers(for user: User, completion: @escaping ([User]) -> ()) {
        var users = [User]()
        
        Constants.Firebase.COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach { document in
                let dict = document.data()
                let newUser = User(dict: dict)
                
                if user.uid != newUser.uid {
                    users.append(newUser)
                }
                
                guard let usersCount = snapshot?.documents.count else { return }
                if users.count == usersCount - 1 {
                    completion(users)
                }
            }
        }
    }
    
    // MARK: - Set Data
    
    static func saveUserData(user: User, completion: @escaping (Error?) -> ()) {
        let data = ["uid": user.uid,
                    "name": user.name,
                    "age": user.age,
                    "bio": user.bio,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge,
                    "imageURLs": user.profileImageURLs] as [String: Any]
        
        Constants.Firebase.COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Firebase.COLLECTION_SWIPES.document(uid).getDocument() { (snapshot, error) in
            let data = [user.uid : isLike]
            
            if snapshot?.exists == true {
                Constants.Firebase.COLLECTION_SWIPES.document(uid).updateData(data)
            } else {
                Constants.Firebase.COLLECTION_SWIPES.document(uid).setData(data)
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
