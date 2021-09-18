//
//  FirebaseAuth.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService {

    public func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    public func userId() -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user.uid
    }

    public func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("Sign out error")
            return false
        }
    }

    public func signIn(email: String,
                       password: String,
                       onSuccess: @escaping  () -> Void,
                       onError: @escaping (String) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                onError(error.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }

    public func signingUp(email: String,
                          password: String,
                          name: String,
                          onSuccess: @escaping  () -> Void,
                          onError: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                onError(error.localizedDescription)
            } else {
                let user = Auth.auth().currentUser
                if let user = user {
                    let firestoreService = FirestoreService()
                    let uid = user.uid

                    firestoreService.createUserDocument(id: uid, name: name) {
                        onSuccess()
                    } onError: { error in
                        onError(error)
                    }

                }
            }
        }
    }
}
