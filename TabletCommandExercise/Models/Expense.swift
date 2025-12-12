//
//  Exepense.swift
//  TabletCommandExercise
//
//  Created by James on 12/10/25.
//

import Foundation
import SwiftUI

struct Expense: Codable {
    let date: Date // Assumes ISO-8601 format
    let shop: String
    let paid: Double
    let paymentType: String
    let items: [ExpenseItem]
    
    private enum CodingKeys: String, CodingKey {
        case date
        case shop
        case paid
        case paymentType
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decode(String.self, forKey: .date)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFractionalSeconds]
        self.date = dateFormatter.date(from: dateString) ?? Date() // Use today+now as an error state

        self.shop = try container.decode(String.self, forKey: .shop)

        if let doublePaid = try? container.decode(Double.self, forKey: .paid) {
            self.paid = doublePaid
        } else if let intPaid = try? container.decode(Int.self, forKey: .paid) {
            self.paid = Double(intPaid)
        } else {
            throw DecodingError.typeMismatch(
                Double.self,
                DecodingError.Context(codingPath: container.codingPath + [CodingKeys.paid],
                                      debugDescription: "paid is not a double or integer")
            )
        }

        self.paymentType = try container.decode(String.self, forKey: .paymentType)

        self.items = try container.decode([ExpenseItem].self, forKey: .items)
    }
}

// MARK: - Helpers

extension Expense {
    var color: Color {
        if paid < 25 {
            return .green
        } else if paid < 100 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var dollarAmount: String {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(floatLiteral: self.paid)) ?? "$0.00"
    }
}
