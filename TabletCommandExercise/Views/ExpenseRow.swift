//
//  ExpenseRow.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import SwiftUI

struct ExpenseRow: View {
    
    var expense: Expense

    var body: some View {
        Text(expense.shop)
    }
}
