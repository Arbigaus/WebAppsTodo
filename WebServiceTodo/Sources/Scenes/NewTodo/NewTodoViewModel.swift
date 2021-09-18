//
//  
//  NewTodoViewModel.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 18/09/21.
//
//

import Foundation

final class NewTodoViewModel {
    // MARK: Output

    @Published var isLoading = false
    @Published var didCreateTodo = false
    @Published var todoTitle = ""
    @Published var todoDescription = ""

    // MARK: - Variables

    private let firestoreService = FirestoreService()

    // MARK: - Functions

    public func createNewTodo() {
        isLoading = true
        let todo = TodoItem(title: todoTitle, description: todoDescription, status: "active")

        firestoreService.addTodo(todo: todo) { [weak self] in
            self?.isLoading = false
            self?.didCreateTodo = true
        } onError: { [weak self] error in
            self?.isLoading = false

        }

    }
}
