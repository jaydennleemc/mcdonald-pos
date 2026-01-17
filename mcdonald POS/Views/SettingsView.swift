//
//  SettingsView.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Replaces SettingsViewController
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // User Info Section
            VStack(spacing: Spacing.m) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(.systemBlue))
                    .padding(.top, Spacing.xl)

                if let user = authViewModel.currentUser {
                    Text(user.username)
                        .font(.displayMedium)
                        .foregroundColor(Color(.label))

                    Text("角色: \(user.role)")
                        .font(.bodyLarge)
                        .foregroundColor(Color(.secondaryLabel))

                    Text("上次登入: \(formatDate(user.lastTime))")
                        .font(.bodySmall)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, Spacing.xl)

            Divider()

            // Logout Button
            Button(action: {
                authViewModel.logout()
                dismiss()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(Color(.systemRed))
                    Text("登出")
                        .font(.buttonLarge)
                        .foregroundColor(Color(.systemRed))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color(.systemRed).opacity(0.1))
                .cornerRadius(8)
            }
            .padding(Spacing.l)

            Spacer()

            // Version Info
            Text("Ver: 1.0.0")
                .font(.bodySmall)
                .foregroundColor(Color(.secondaryLabel))
                .padding(.bottom, Spacing.l)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(createMockAuthViewModel())
        }
    }

    static func createMockAuthViewModel() -> AuthViewModel {
        let vm = AuthViewModel(databaseManager: DatabaseManager())
        vm.currentUser = User(
            username: "staff",
            password: "123456",
            role: "STAFF",
            lastTime: Date()
        )
        return vm
    }
}
