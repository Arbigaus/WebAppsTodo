//
//  LoginViewModel.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import Foundation

final class LoginViewModel {
    // MARK: Output

    @Published var isLoading = false
    @Published var didLogin = false
    @Published var email = ""
    @Published var password = ""

    // MARK: - Variables
    private let authService = FirebaseAuthService()

    // MARK: - Functions

    public func signIn() {
        isLoading = true

        authService.signIn(email: email, password: password) { [weak self] in
            self?.isLoading = false
            self?.didLogin = true
        } onError: { [weak self] error in
            self?.isLoading = false
            self?.didLogin = false
            print(error)
        }

    }
    
}
