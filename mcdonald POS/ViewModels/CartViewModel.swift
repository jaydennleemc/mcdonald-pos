//
//  CartViewModel.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - Cart state management (replaces NotificationCenter pattern)
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var billItems: [BillItem] = []
    @Published var subtotal: Float64 = 0.0
    @Published var total: Float64 = 0.0
    
    // MARK: - Cart Operations
    func addItem(_ item: BillItem) {
        billItems.append(item)
        recalculateTotal()
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < billItems.count else { return }
        billItems.remove(at: index)
        recalculateTotal()
    }
    
    func removeItem(_ item: BillItem) {
        if let index = billItems.firstIndex(where: { $0.id == item.id }) {
            billItems.remove(at: index)
            recalculateTotal()
        }
    }
    
    func clearCart() {
        billItems.removeAll()
        recalculateTotal()
    }
    
    // MARK: - Price Calculation
    private func recalculateTotal() {
        subtotal = billItems.reduce(0) { total, item in
            total + item.totalPrice
        }

        total = subtotal  // No tax in this implementation
    }
    
    // MARK: - Computed Properties
    var itemCount: Int {
        billItems.count
    }
    
    var hasItems: Bool {
        !billItems.isEmpty
    }
    
    var formattedSubtotal: String {
        String(format: "HKD $%.2f", subtotal)
    }
    
    var formattedTotal: String {
        String(format: "HKD $%.2f", total)
    }
}
