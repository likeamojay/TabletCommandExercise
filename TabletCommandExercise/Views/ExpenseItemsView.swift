//
//  ExpenseItemsView.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import SwiftUI

struct ExpenseItemsView: View {

    let expense: Expense

    var body: some View {
        VStack(alignment: .center) {
            List(expense.items) { item in
                ExpenseItemRow(item: item)
              }
              .listStyle(.plain)
            Divider()
            Text("Amount tendered: \(expense.paid.dollarAmount)")
            Text("Total: \(expense.totalItemsSum.dollarAmount)")
                .font(.largeTitle).bold()
            Text("Change due: \(expense.changeDue.dollarAmount)")
            Divider()
        }
        .navigationTitle(expense.shop)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - List Row

struct ExpenseItemRow: View {
    
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.price.dollarAmount)
        }
    }
}

#Preview {
    ExpensesView()
}
