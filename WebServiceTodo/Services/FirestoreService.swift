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
    private let authService = FirebaseAuthService()

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

    public func getUser(onSuccess: @escaping (User) -> Void, onError: @escaping (String) -> Void) {
        guard let userId = authService.userId() else {
            onError("User not logged")
            return
        }
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                var todoList: [TodoItem] = []

                if let list = data?["todoList"] as? [Any] {
                    list.forEach({ item  in
                        if let todo = item as? [String: Any] {
                            todoList.append(TodoItem(title: todo["title"] as? String ?? "",
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

    public func addTodo(todo: TodoItem, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard let userId = authService.userId() else {
            onError("User not logged")
            return
        }
        let docRef = db.collection("users").document(userId)

        let todoItem: [String: Any] = ["title": todo.title,
                                       "description": todo.description,
                                       "status": todo.status]

        docRef.updateData([
            "todoList": FieldValue.arrayUnion([todoItem])
        ]) { error in
            guard error != nil else {
                onSuccess()
                return
            }
            print(error.debugDescription)
            onError(error.debugDescription)
        }
    }

    public func removeTodo(todo: TodoItem, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard let userId = authService.userId() else {
            onError("User not logged")
            return
        }
        let docRef = db.collection("users").document(userId)

        let todoItem: [String: Any] = ["title": todo.title,
                                       "description": todo.description,
                                       "status": todo.status]

        docRef.updateData([
            "todoList": FieldValue.arrayRemove([todoItem])
        ]) { error in
            guard error != nil else {
                onSuccess()
                return
            }
            print(error.debugDescription)
            onError(error.debugDescription)
        }
    }

    public func makeTodoDone(todo: TodoItem, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let todoToRemove = TodoItem(title: todo.title, description: todo.description, status: "active")

        removeTodo(todo: todoToRemove) { [weak self] in
            self?.addTodo(todo: todo) {
                onSuccess()
            } onError: { error in
                onError(error)
            }

        } onError: { error in
            onError(error)
        }

    }

}

public struct User: Codable {
    let name: String
    let todoList: [TodoItem]?
}

public struct TodoItem: Codable {
    let title: String
    let description: String
    let status: String
}

