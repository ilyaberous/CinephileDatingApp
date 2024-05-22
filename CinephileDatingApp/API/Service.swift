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
        
        let query = Constants.Firebase.COLLECTION_USERS
            .whereField("age", isGreaterThan: user.minSeekingAge)
            .whereField("age", isLessThan: user.maxSeekingAge)
        
        fetchSwipes { swipedUserIDs in
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                snapshot.documents.forEach { document in
                    let dictionary = document.data()
                    let user = User(dict: dictionary)
                    
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return }
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    static func fetchSwipes(completion: @escaping([String: Bool]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Firebase.COLLECTION_SWIPES.document(uid).getDocument() { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return 
            }
            completion(data)
        }
    }
    
    static func fetchMatches(completion: @escaping ([Match]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { (snapshot, error) in
            guard let data = snapshot else { return }
            
            let matches = data.documents.map({ Match(dictionary: $0.data()) })
            completion(matches)
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
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> ())?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Firebase.COLLECTION_SWIPES.document(uid).getDocument() { (snapshot, error) in
            let data = [user.uid : isLike]
            
            if snapshot?.exists == true {
                Constants.Firebase.COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                Constants.Firebase.COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Firebase.COLLECTION_SWIPES.document(user.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[uid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
    static func uploadMatch(user: User, matchedUser: User) {
        guard let matchedUserProfileImageURL = matchedUser.profileImageURLs.first else { return }
        guard let userProfileImageURL = user.profileImageURLs.first else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                               "name": matchedUser.name,
                               "profileImageURL": matchedUserProfileImageURL]
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(user.uid).collection("matches")
            .document(matchedUser.uid).setData(matchedUserData)
        
        let userData = ["uid": user.uid,
                               "name": user.name,
                               "profileImageURL": userProfileImageURL]
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches")
            .document(user.uid).setData(userData)
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
