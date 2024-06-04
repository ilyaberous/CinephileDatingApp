//
//  MessagesService.swift
//  CinephileDatingApp
//
//  Created by Ilya on 31.05.2024.
//

import Foundation
import Firebase

class MessagesService {
    
    static let shared = MessagesService()
    
    private init() {}
    
    func createMessage(sender: User, companion: User, text: String, completion: @escaping (Error) -> ()) {
        guard !text.isEmpty else {
            return
        }
        
        let messageID = UUID().uuidString
        let timestamp = Timestamp(date: Date())
        
        let message: [String: Any] = [
            "senderID": sender.uid,
            "text": text,
            "timestamp": timestamp,
            "isRead": false
            ]

        
        let batch = Firestore.firestore().batch()
        
        let chatUpdateData: [String: Any] = [
            "lastMessage": text,
            "authorMessage": sender.uid,
            "lastMessageTimestamp": timestamp,
            "isRead": false
            ]
        
        let currentUserChatRef = Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(sender.uid).collection("chats").document(companion.uid)
        let matchedUserChatRef = Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(companion.uid).collection("chats").document(sender.uid)
        
        let currentUserMessageRef = Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(sender.uid).collection("messages").document(companion.uid).collection("messages").document(messageID)
        let matchedUserMessageRef = Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(companion.uid).collection("messages").document(sender.uid).collection("messages").document(messageID)
        
        currentUserChatRef.getDocument { (document, error) in
            if let document = document, document.exists {
                batch.setData(message, forDocument: currentUserMessageRef)
                batch.setData(message, forDocument: matchedUserMessageRef)
                batch.updateData(chatUpdateData, forDocument: currentUserChatRef)
                batch.updateData(chatUpdateData, forDocument: matchedUserChatRef)
                
                batch.commit { error in
                    if let error = error {
                        completion(error)
                        print("DEBUG: Error sending message: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: Sucsesfully sending message")
                        print("DEBUG: uid message: \(messageID)")
                    }
                }
            } else {
                let initialChatDataForCurrentUser: [String: Any] = [
                    "matchedUserID": companion.uid,
                    "name": companion.name,
                    "profileImageURL": companion.profileImageURLs.first,
                    "lastMessage": text,
                    "authorMessage": sender.uid,
                    "lastMessageTimestamp": timestamp,
                    "isRead": false
                ]
                
                let initialChatDataForMatchedUser: [String: Any] = [
                    "matchedUserID": sender.uid,
                    "name": sender.name,
                    "profileImageURL": sender.profileImageURLs.first,
                    "lastMessage": text,
                    "authorMessage": sender.uid,
                    "lastMessageTimestamp": timestamp,
                    "isRead": false
                ]
                
                batch.setData(initialChatDataForCurrentUser, forDocument: currentUserChatRef)
                batch.setData(initialChatDataForMatchedUser, forDocument: matchedUserChatRef)
                batch.setData(message, forDocument: currentUserMessageRef)
                batch.setData(message, forDocument: matchedUserMessageRef)

                batch.commit { error in
                    if let error = error {
                        completion(error)
                        print("Error creating chat and sending message: \(error)")
                    } else {
                        print("Chat created and message sent successfully")
                    }
                }
            }
        }
    }
    
    func createMessagesListener(userID: String, companionID: String, completion: @escaping ((Result<[Message], Error>) -> ())) -> ListenerRegistration {
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID).collection("messages").document(companionID).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                print("DEBUG: Error listening for messages: \(error)")
                return
            }
            
            let messages = snapshot?.documents.compactMap { document in
                let data = document.data()
                
                guard let senderID = data["senderID"] as? String,
                      let text = data["text"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp,
                      let isRead = data["isRead"] as? Bool else { return nil }
                
                let sender = Sender(senderId: senderID, displayName: "")
                let sentData = timestamp.dateValue()
                let message = Message(sender: sender, messageId: document.documentID, sentDate: sentData, kind: .text(text), isRead: isRead)
                return message
            } ?? [Message]()
            
            completion(.success(messages))
        }
    }
    
    func createChatsListener(userID: String, completion: @escaping ((Result<[Chat], Error>) -> ())) -> ListenerRegistration {
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID).collection("chats").order(by: "lastMessageTimestamp", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                print("DEBUG: Error listening for chats: \(error)")
                return
            }
            
           // print("DEBUG: snapshot documents: \(snapshot?.documents)")
            let chats = snapshot?.documents.compactMap { document in
                let data = document.data()
                let chat = Chat(
                    //userID: data["userID"] as? String  ?? "",
                    matchedUserID: data["matchedUserID"] as? String ?? "",
                    name: data["name"] as? String  ?? "",
                    profileImageURL: data["profileImageURL"] as? String ?? "",
                    lastMessage: data["lastMessage"] as? String  ?? "",
                    authorMessage: data["authorMessage"] as? String ?? "",
                    lastMessageTimestamp: data["lastMessageTimestamp"] as? Timestamp ?? nil,
                    isRead: data["isRead"] as? Bool ?? false
                    )
                return chat
            } ?? [Chat]()
            
            completion(.success(chats))
        }
    }
    
    
    func makeMessageRead(messageID: String, userID: String, matchedUserID: String) {
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID).collection("messages").document(matchedUserID).collection("messages").document(messageID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID).collection("chats").document(matchedUserID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(matchedUserID).collection("messages").document(userID).collection("messages").document(messageID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(matchedUserID).collection("chats").document(userID).updateData(
            ["isRead": true]
        )
    }
}
