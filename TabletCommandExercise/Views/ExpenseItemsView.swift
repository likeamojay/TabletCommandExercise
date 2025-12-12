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
            Rectangle()
                .frame(width: .infinity, height: 2)
                .foregroundStyle(.black)
            List(expense.items, id: \.price) { item in
                ExpenseItemRow(item: item)
              }
              .listStyle(.plain)
            Text("Total: \(expense.totalString)")
                .font(.largeTitle).bold()
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
            Text(item.dollarAmount)
        }
    }
}

#Preview {
    ExpensesView()
}
