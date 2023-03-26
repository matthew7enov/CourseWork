//
//  UserService.swift
//  CourseWork
//
//  Created by Matvei Semenov on 13/12/2022.
//

import Foundation
import FirebaseAuth

class UserService {
    struct Credentials {
        let token: String
        let refreshToken: String
    }

    static let shared = UserService()

    var currentUser: User?

    var isUserSignedIn: Bool {
        Auth.auth().currentUser != nil
    }

    init() {
        if let user = Auth.auth().currentUser {
            currentUser = .init(id: user.uid, email: user.email ?? "")
        } else {
            currentUser = nil
        }
    }

    func signUp(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let result = result,
                  let email = result.user.email else {
                completion(false)
                return
            }
            self?.currentUser = .init(id: result.user.uid , email: email)
            completion(true)
        }
    }

    func signIn(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let result = result,
                  let email = result.user.email else {
                completion(false)
                return
            }
            self?.currentUser = .init(id: result.user.uid , email: email)
            completion(true)
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
