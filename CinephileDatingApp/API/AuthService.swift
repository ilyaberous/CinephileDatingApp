//
//  AuthService.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.04.2024.
//

import UIKit
import Firebase
import FirebaseAuth

struct AuthCredentials {
    let email: String
    let password: String
    let name: String
    let profileImage: UIImage
}
struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials,
                             completion: @escaping ((Error?)) -> ()) {
        Service.uploadImage(image: credentials.profileImage) { imgURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Error signing up \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "name": credentials.name,
                            "imageURLs": [imgURL],
                            "uid": uid,
                            "age": 18] as [String: Any]
                
                Constants.Firebase.COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
