//
//  CartView.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Replaces CashierViewController
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingPayment = false
    @State private var showingClearConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("購物車")
                    .font(.displayMedium)
                    .foregroundColor(Color(.label))

                Spacer()

                if cartViewModel.hasItems {
                    Button(action: {
                        showingClearConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color(.systemRed))
                    }
                    .padding(.trailing, Spacing.m)

                    Text("共 \(cartViewModel.itemCount) 件商品")
                        .font(.bodySmall)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            .padding(Spacing.l)
            .background(Color(.systemGray6))

            Divider()

            // Cart Items List
            if cartViewModel.hasItems {
                List {
                    ForEach(cartViewModel.billItems) { item in
                        CartItemRow(item: item)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    cartViewModel.removeItem(item)
                                } label: {
                                    Label("刪除", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())

                // Summary
                VStack(spacing: Spacing.s) {
                    HStack {
                        Text("小計")
                            .font(.bodyLarge)
                            .foregroundColor(Color(.secondaryLabel))
                        Spacer()
                        Text(cartViewModel.formattedSubtotal)
                            .font(.bodyLarge)
                            .foregroundColor(Color(.label))
                    }

                    HStack {
                        Text("總計")
                            .font(.displayMedium)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemBlue))
                        Spacer()
                        Text(cartViewModel.formattedTotal)
                            .font(.displayMedium)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemBlue))
                    }
                    .padding(.top, Spacing.xs)
                }
                .padding(Spacing.l)
                .background(Color(.systemGray6))

                // Payment Button
                Button(action: {
                    showingPayment = true
                }) {
                    Text("去支付")
                        .font(.buttonLarge)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
                .padding(Spacing.l)
                .background(Color(.systemBackground))
            } else {
                // Empty State
                VStack(spacing: Spacing.l) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.top, Spacing.xxxl)

                    Text("購物車是空的")
                        .font(.displayMedium)
                        .foregroundColor(Color(.label))

                    Text("去菜單選購美味的餐點吧！")
                        .font(.bodyLarge)
                        .foregroundColor(Color(.secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPayment) {
            PaymentView()
        }
        .alert("清空購物車", isPresented: $showingClearConfirmation) {
            Button("取消", role: .cancel) { }
            Button("清空", role: .destructive) {
                cartViewModel.clearCart()
            }
        } message: {
            Text("確定要清空所有商品嗎？")
        }
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: BillItem

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.m) {
                // Food Image
                Image(item.food.image_zh)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .background(Color(.systemGray6))

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    // Main Food Name
                    Text(item.food.name_zh)
                        .font(.bodyLarge)
                        .fontWeight(.medium)
                        .lineLimit(2)

                    // Meal Details
                    if item.is_set_meal {
                        if let option = item.option_food {
                            Text("配菜: \(option.name_zh)")
                                .font(.bodySmall)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        if let drink = item.option_drink {
                            Text("飲品: \(drink.name_zh)")
                                .font(.bodySmall)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }

                    // Price
                    Text(item.formattedPrice)
                        .font(.displaySmall)
                        .foregroundColor(Color(.systemBlue))
                        .fontWeight(.semibold)
                }

                Spacer()
            }
        }
        .padding(Spacing.s)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Payment View
struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPayment: String?

    let paymentMethods = [
        ("visapay", "Visa Pay"),
        ("masterpay", "Mastercard Pay"),
        ("alipay", "Alipay"),
        ("wechatpay", "WeChat Pay"),
        ("unionpay", "UnionPay")
    ]

    var body: some View {
        NavigationStack {
            List(paymentMethods, id: \.0) { method in
                PaymentMethodRow(
                    imageName: method.0,
                    name: method.1,
                    isSelected: selectedPayment == method.0
                )
                .onTapGesture {
                    selectedPayment = method.0
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("選擇付款方式")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("確認") {
                        processPayment()
                    }
                    .disabled(selectedPayment == nil)
                }
            }
        }
    }

    private func processPayment() {
        // Simulate payment processing
        // In real app, would integrate with payment gateway
        dismiss()
    }
}

// MARK: - Payment Method Row
struct PaymentMethodRow: View {
    let imageName: String
    let name: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: Spacing.m) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(8)

            Text(name)
                .font(.bodyLarge)
                .foregroundColor(Color(.label))

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(.systemBlue))
                    .font(.title2)
            }
        }
        .padding(Spacing.s)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color(.systemBlue).opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color(.systemBlue) : Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Preview
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CartView()
                .environmentObject(createMockCartViewModel())
        }
    }

    static func createMockCartViewModel() -> CartViewModel {
        let vm = CartViewModel()
        let mockFood = Food(
            id: 1,
            catalogId: 1,
            name_zh: "巨無霸®",
            name_en: "Big Mac",
            image_zh: "巨無霸®",
            image_en: "Big Mac",
            price: 25.0,
            meal_price: 30.0,
            is_breakfasts: false,
            is_set_meal: true,
            is_set_option: false,
            is_set_drink: false
        )
        let mockOption = Food(
            id: 2,
            catalogId: 1,
            name_zh: "薯條(中)",
            name_en: "Medium Fries",
            image_zh: "薯條",
            image_en: "Fries",
            price: 10.0,
            meal_price: 12.0,
            is_breakfasts: false,
            is_set_meal: false,
            is_set_option: true,
            is_set_drink: false
        )
        let mockDrink = Food(
            id: 3,
            catalogId: 2,
            name_zh: "可口可樂(中)",
            name_en: "Coca Cola Medium",
            image_zh: "汽水",
            image_en: "Soda",
            price: 8.0,
            meal_price: 10.0,
            is_breakfasts: false,
            is_set_meal: false,
            is_set_option: false,
            is_set_drink: true
        )

        vm.addItem(BillItem(is_set_meal: true, food: mockFood, option_food: mockOption, option_drink: mockDrink))
        return vm
    }
}
