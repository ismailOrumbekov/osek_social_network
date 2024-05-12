//
//  DatabaseManager.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation

import FirebaseFirestore

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init(){}
    
    public func insert(post: Post, email: String, completion: @escaping(Bool) -> Void){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        let data: [String : Any] = [
            "id": post.identigier,
            "title" : post.title,
            "body" : post.text,
            "url" : post.headerImageUrl?.absoluteString ?? "Error",
            "created" : post.timestamp,
            
        ]
        database.collection("users")
            .document(userEmail)
            .collection("posts")
            .document(post.identigier)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func getAllPosts(completion: @escaping([Post]) -> Void){
        database
            .collection("users")
            .getDocuments { [weak self] snapshot, error in
            guard let document = snapshot?.documents.compactMap({$0.data()}),
                  error == nil else{return}
            
                guard let self = self else {return}
            let emails: [String] = document.compactMap({return $0["email"] as? String})
            
            guard !emails.isEmpty else{
                completion([])
                return
            }
            let group = DispatchGroup()
            var result: [Post] = []
            for email in emails{
                group.enter()
                self.getPosts(for: email, completion: { userPosts in
                    defer{
                        group.leave()
                    }
                    
                    result.append(contentsOf: userPosts)
                })
                
                group.notify(queue: .global()) {
                    
                    result.sort { $0.timestamp < $1.timestamp }
                    completion(result)
                }
            }
        }
    }
    
    public func getPosts(for email: String, completion: @escaping([Post]) -> Void){
        let dispatchGroup = DispatchGroup()

        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database.collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapShot, error in
                guard let documents = snapShot?.documents.compactMap({$0.data()}),
                      error == nil else{
                    return
                }
                print("vnutri")
                var posts: [Post] = []
                for dictionary in documents {
                    guard let id = dictionary["id"] as? String,
                        let title = dictionary["title"] as? String,
                        let body = dictionary["body"] as? String,
                        let url = dictionary["url"] as? String,
                        let created = dictionary["created"] as? TimeInterval
                        else{ fatalError() }
                    
                    dispatchGroup.enter()
                    
                    self.getUser(email: email) { user in
                        guard let user = user else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        let post = Post(identigier: id,
                                        title: title,
                                        timestamp: created,
                                        headerImageUrl: URL(string: url),
                                        text: body,
                                        author: user)
                        posts.append(post)
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("All users retrieved")
                    completion(posts)
                }
        }
    }

    
    public func insert(user: User, completion: @escaping(Bool) -> Void){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data = [
            "email" : user.email,
            "nickName" : user.nickName
        ]
        database.collection("users").document(documentId).setData(data){ error in
            completion(error == nil)
        }
    }
    
    public func getUser(email: String, completion: @escaping(User?) -> Void){
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database.collection("users").document(documentId).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: String],
                    error == nil,
                    let nickname = data["nickName"] else {return}
            let ref = data["profile_photo"]
            let user = User(nickName: nickname, email: email, profileRef: ref)
            completion(user)
        }
    }

    
    public func updateProfilePhoto(email: String, completion: @escaping(Bool) -> Void){
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        let photoRef = "profile_pictures/\(path)/photo.png"
        let dbRef = database.collection("users").document(path)
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {return}
            data["profile_photo"] = photoRef
            dbRef.setData(data) { error in
                completion(error == nil
                )
            }
        }
    }
    
}

