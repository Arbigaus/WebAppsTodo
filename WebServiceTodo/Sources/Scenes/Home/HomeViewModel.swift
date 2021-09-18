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
    @Published var todoList: [TodoList] = []

    // MARK: - Variables

    private let authService = FirebaseAuthService()
    private let firestoreService = FirestoreService()

    // MARK: - Functions

    public func getUserData() {
        isLoading = true
        guard let userId = authService.userId() else { return }
        firestoreService.getUser(id: userId) { [weak self] user in
            self?.name = user.name
            self?.todoList = user.todoList ?? []
            self?.isLoading = false
            } onError: { [weak self] _ in
                self?.signOut()
            }
    }


    public func signOut() {
        didSignOut = authService.signOut()
    }
}
