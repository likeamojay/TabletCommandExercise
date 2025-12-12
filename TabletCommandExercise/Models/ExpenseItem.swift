//
//  ExpenseItem.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import Foundation

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let ean: String
    let price: Double
}
