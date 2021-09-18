//
//  FirestoreService.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 17/09/21.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    fileprivate let db = Firestore.firestore()

    public func createUserDocument(id: String,
                                   name: String,
                                   onSuccess: @escaping  () -> Void,
                                   onError: @escaping (String) -> Void) {

        let todoExample: [String: Any] = ["title": "Example",
                                          "description": "This is a TODO example",
                                          "status": "active"]

        let docData: [String: Any] = [
            "name": name,
            "todoList": [todoExample]
        ]

        db.collection("users").document(id).setData(docData) { err in
            if let err = err {
                onError("Error writing document: \(err)")
                print("Error writing document: \(err)")
            } else {
                onSuccess()
                print("Document successfully written!")
            }
        }
    }

    public func getUser(id: String, onSuccess: @escaping  (User) -> Void, onError: @escaping (String) -> Void) {
        let docRef = db.collection("users").document(id)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                var todoList: [TodoList] = []

                if let list = data?["todoList"] as? [Any] {
                    list.forEach({ item  in
                        if let todo = item as? [String: Any] {
                            todoList.append(TodoList(title: todo["title"] as? String ?? "",
                                            description: todo["description"] as? String ?? "",
                                            status: todo["status"] as? String ?? ""))
                        }
                    })
                }

                let user = User(name: name,
                                todoList: todoList)
                onSuccess(user)
            } else {
                onError("Document does not exist")
                print("Document does not exist")
            }
        }
    }
}

public struct User: Codable {
    let name: String
    let todoList: [TodoList]?
}

public struct TodoList: Codable {
    let title: String
    let description: String
    let status: String
}

