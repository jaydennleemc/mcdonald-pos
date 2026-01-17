//
//  LoginView.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Replaces LoginViewController
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = "staff"
    @State private var password: String = "123456"
    @FocusState private var isUsernameFocused: Bool
    @FocusState private var isPasswordFocused: Bool

    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()

            // Main content
            GeometryReader { geometry in
                VStack(spacing: 32) {
                    // Logo
                    Image("mcdonalds_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)

                    // Welcome Text
                    Text("欢迎使用 McDonald POS")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(.label))

                    // Input Container
                    VStack(spacing: 0) {
                        // Username Field
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(.systemBlue))
                                .frame(width: 20)

                            TextField("用户名", text: $username)
                                .focused($isUsernameFocused)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        .background(Color(.systemBackground))

                        Divider()
                            .padding(.leading, 44)

                        // Password Field
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(.systemBlue))
                                .frame(width: 20)

                            SecureField("密码", text: $password)
                                .focused($isPasswordFocused)
                                .textFieldStyle(.plain)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .frame(maxWidth: 500)

                    // Error Message
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.systemRed))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 500)
                    }

                    // Login Button
                    Button(action: {
                        Task {
                            await authViewModel.login(username: username, password: password)
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("登 录")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: 500)
                    .frame(height: 56)
                    .background(Color(.systemBlue))
                    .cornerRadius(12)
                    .disabled(authViewModel.isLoading)
                    .opacity(authViewModel.isLoading ? 0.7 : 1.0)

                    // Hint
                    Text("💡 提示: 默认账号 staff / 密码 123456")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 500)
                }
                .padding(.horizontal, 48)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - SwiftUI Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel(databaseManager: DatabaseManager()))
    }
}
