//
//  
//  SignOnViewModel.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import Foundation

final class SignOnViewModel {
    // MARK: Output

    @Published var isLoading = false
    @Published var didSignOn = false
    @Published var isValidPassword = false
    @Published var name = ""
    @Published var email = ""
    @Published var password = "" {
        didSet {
            isValidPassword = password.count >= 6
        }
    }

    // MARK: - Variables
    private let authService = FirebaseAuthService()

    public func signOn() {
        isLoading = true

        authService.signingUp(email: email, password: password, name: name) { [weak self] in
            self?.isLoading = false
            self?.didSignOn = true
        } onError: { [weak self] error in
            self?.isLoading = false
            print(error)
        }

    }

}
