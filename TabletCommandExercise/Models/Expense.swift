//
//  Exepense.swift
//  TabletCommandExercise
//
//  Created by James on 12/10/25.
//

import Foundation

struct Expense: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let shop: String
    let paid: Double
    let paymentType: String
    let items: [ExpenseItem]
}
