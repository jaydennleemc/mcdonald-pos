//
//  CatalogView.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Replaces CatalogViewController
//

import SwiftUI

struct CatalogView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedCatalog: Catalog?
    @State private var showingMealOptions = false
    @State private var showingMealDrinks = false
    @State private var selectedFood: Food?
    @State private var selectedOption: Food?
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            // Catalog Categories (Horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.m) {
                    ForEach(databaseManager.catalogs) { catalog in
                        CatalogCategoryCell(
                            catalog: catalog,
                            isSelected: selectedCatalog?.id == catalog.id
                        )
                        .onTapGesture {
                            selectCatalog(catalog)
                        }
                    }
                }
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.s)
            }
            .background(Color(.systemGray6))

            Divider()

            // Food Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: Spacing.m)], spacing: Spacing.m) {
                    ForEach(databaseManager.foods) { food in
                        FoodCell(food: food)
                            .onTapGesture {
                                handleFoodSelection(food)
                            }
                    }
                }
                .padding(Spacing.l)
            }
        }
        .onAppear {
            Task {
                await loadInitialData()
            }
        }
        .alert("錯誤", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("確定", role: .cancel) { }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
        .sheet(isPresented: $showingMealOptions) {
            if let food = selectedFood {
                MealOptionSelectionView(
                    food: food,
                    onOptionSelected: { option in
                        selectedOption = option
                        showingMealOptions = false
                        showingMealDrinks = true
                    }
                )
                .environmentObject(databaseManager)
            }
        }
        .sheet(isPresented: $showingMealDrinks) {
            if let food = selectedFood, let option = selectedOption {
                MealDrinkSelectionView(
                    food: food,
                    option: option,
                    onAddToCart: { drink in
                        addToCart(food: food, option: option, drink: drink)
                        showingMealDrinks = false
                    }
                )
                .environmentObject(databaseManager)
            }
        }
    }

    private func loadInitialData() async {
        do {
            if databaseManager.catalogs.isEmpty {
                try await databaseManager.loadCatalogs()
                if let firstCatalog = databaseManager.catalogs.first {
                    selectedCatalog = firstCatalog
                    try await databaseManager.loadFoods(catalogId: firstCatalog.id)
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func selectCatalog(_ catalog: Catalog) {
        selectedCatalog = catalog
        Task {
            do {
                try await databaseManager.loadFoods(catalogId: catalog.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func handleFoodSelection(_ food: Food) {
        if food.is_set_meal || food.is_breakfasts {
            selectedFood = food
            showingMealOptions = true
        } else {
            // Add single item directly
            let billItem = BillItem(
                is_set_meal: false,
                food: food,
                option_food: nil,
                option_drink: nil
            )
            cartViewModel.addItem(billItem)
        }
    }

    private func addToCart(food: Food, option: Food, drink: Food) {
        let billItem = BillItem(
            is_set_meal: true,
            food: food,
            option_food: option,
            option_drink: drink
        )
        cartViewModel.addItem(billItem)
    }
}

// MARK: - Catalog Category Cell
struct CatalogCategoryCell: View {
    let catalog: Catalog
    let isSelected: Bool

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(catalog.image_zh)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            Text(catalog.name_zh)
                .font(.displaySmall)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 128)
        }
        .padding(Spacing.s)
        .background(isSelected ? Color(.systemBlue) : Color(.systemBackground))
        .foregroundColor(isSelected ? .white : Color(.label))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color(.systemBlue) : Color(.systemGray4), lineWidth: 2)
        )
    }
}

// MARK: - Food Cell
struct FoodCell: View {
    let food: Food

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(food.image_zh)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .cornerRadius(8)

            Text(food.name_zh)
                .font(.bodyLarge)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)

            if food.is_set_meal || food.is_breakfasts {
                Text("套餐 \(formatPrice(food.meal_price))")
                    .font(.labelMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.s)
                    .padding(.vertical, Spacing.xs)
                    .background(Color(.systemBlue))
                    .cornerRadius(6)
            } else {
                Text(formatPrice(food.price))
                    .font(.displaySmall)
                    .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(Spacing.s)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }

    private func formatPrice(_ price: Float64) -> String {
        String(format: "HKD $%.2f", price)
    }
}

// MARK: - Meal Option Selection View
struct MealOptionSelectionView: View {
    let food: Food
    let onOptionSelected: (Food) -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var options: [Food] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                if options.isEmpty {
                    ProgressView("載入中...")
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: Spacing.m)], spacing: Spacing.m) {
                            ForEach(options) { option in
                                FoodCell(food: option)
                                    .onTapGesture {
                                        onOptionSelected(option)
                                    }
                            }
                        }
                        .padding(Spacing.l)
                    }
                }
            }
            .navigationTitle("選擇配菜")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                Task {
                    await loadOptions()
                }
            }
            .alert("錯誤", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("確定", role: .cancel) { }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
        }
    }

    private func loadOptions() async {
        do {
            options = try await databaseManager.loadFoodOptions(isBreakfasts: food.is_breakfasts)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Meal Drink Selection View
struct MealDrinkSelectionView: View {
    let food: Food
    let option: Food
    let onAddToCart: (Food) -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var drinks: [Food] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                if drinks.isEmpty {
                    ProgressView("載入中...")
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: Spacing.m)], spacing: Spacing.m) {
                            ForEach(drinks) { drink in
                                FoodCell(food: drink)
                                    .onTapGesture {
                                        onAddToCart(drink)
                                    }
                            }
                        }
                        .padding(Spacing.l)
                    }
                }
            }
            .navigationTitle("選擇飲品")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                Task {
                    await loadDrinks()
                }
            }
            .alert("錯誤", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("確定", role: .cancel) { }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
        }
    }

    private func loadDrinks() async {
        do {
            drinks = try await databaseManager.loadDrinkOptions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Preview
struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
            .environmentObject(DatabaseManager())
            .environmentObject(CartViewModel())
    }
}
