//
//  AuthViewModel.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Authentication state management
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let databaseManager: DatabaseManager

    // MARK: - Initialization
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }

    // MARK: - Authentication
    @MainActor
    func login(username: String, password: String) async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "用户名和密码不能为空"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await databaseManager.loginUser(username: username, password: password)

            currentUser = user
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }

        isLoading = false
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
        isLoading = false
    }
}
