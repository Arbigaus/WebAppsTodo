//
//  
//  HomeViewModel.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import Foundation

final class HomeViewModel {
    // MARK: Output

    @Published var isLoading = false
    @Published var didSignOut = false
    @Published var title = ""
    @Published var text = ""
    @Published var name = ""
    @Published var todoList: [TodoItem] = []
    @Published var todoListDone: [TodoItem] = []

    // MARK: - Variables

    private let authService = FirebaseAuthService()
    private let firestoreService = FirestoreService()

    // MARK: - Functions

    public func getUserData() {
        isLoading = true

        firestoreService.getUser() { [weak self] user in
            self?.name =  "Olá, \(user.name)"
            self?.todoList = user.todoList?.filter { $0.status == "active" } ?? []
            self?.todoListDone = user.todoList?.filter { $0.status == "done" } ?? []
            self?.isLoading = false
            } onError: { [weak self] _ in
                self?.signOut()
            }
    }

    public func removeTodoItem(item: TodoItem) {
        isLoading = true

        firestoreService.removeTodo(todo: item) { [weak self] in
            self?.isLoading = false
            self?.getUserData()
        } onError: { error in
            self.isLoading = false
            print(error)
        }
    }

    public func doneTodo(item: TodoItem) {
        isLoading = true

        let todo = TodoItem(title: item.title, description: item.description, status: "done")
        firestoreService.makeTodoDone(todo: todo) {[weak self] in
            self?.isLoading = false
            self?.getUserData()
        } onError: { error in
            self.isLoading = false
            print(error)
        }
    }

    public func signOut() {
        didSignOut = authService.signOut()
    }
}
