//
//  McDonaldPOSApp.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Replaces AppDelegate/SceneDelegate
//

import SwiftUI

@main
struct McDonaldPOSApp: SwiftUI.App {
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Root content view - handles authentication state
struct ContentView: SwiftUI.View {
    @StateObject private var databaseManager = DatabaseManager()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var authViewModel: AuthViewModel

    init() {
        let dbManager = DatabaseManager()
        _databaseManager = StateObject(wrappedValue: dbManager)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(databaseManager: dbManager))
        _cartViewModel = StateObject(wrappedValue: CartViewModel())
    }

    var body: some SwiftUI.View {
        Group {
            if authViewModel.isAuthenticated {
                MainSplitView()
                    .environmentObject(databaseManager)
                    .environmentObject(cartViewModel)
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    .environmentObject(databaseManager)
            }
        }
    }
}

// Main split view for authenticated users - Menu (left) + Cart (right)
struct MainSplitView: SwiftUI.View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .menu

    enum Tab: String, CaseIterable {
        case menu = "菜單"
        case cart = "購物車"
        case settings = "設定"
    }

    var body: some SwiftUI.View {
        NavigationSplitView {
            // Sidebar - Tab selection
            VStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: iconForTab(tab))
                                .frame(width: 24)
                            Text(tab.rawValue)
                                .font(.body)
                            Spacer()
                            if tab == .cart && cartViewModel.billItems.count > 0 {
                                Text("\(cartViewModel.billItems.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(.systemBlue))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .background(selectedTab == tab ? Color(.systemBlue).opacity(0.1) : Color(.systemBackground))
                        .foregroundColor(selectedTab == tab ? Color(.systemBlue) : Color(.label))
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationTitle("McDonald's")
            .navigationBarTitleDisplayMode(.large)
        } detail: {
            // Main content area
            switch selectedTab {
            case .menu:
                NavigationStack {
                    CatalogView()
                        .navigationTitle("菜單")
                }
            case .cart:
                NavigationStack {
                    CartView()
                        .navigationTitle("購物車")
                }
            case .settings:
                NavigationStack {
                    SettingsView()
                        .navigationTitle("設定")
                }
            }
        }
    }

    private func iconForTab(_ tab: Tab) -> String {
        switch tab {
        case .menu: return "book.fill"
        case .cart: return "cart.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
