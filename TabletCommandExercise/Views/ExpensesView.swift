//
//  ExpensesView.swift
//  TabletCommandExercise
//
//  Created by James on 12/10/25.
//

import SwiftUI

struct ExpensesView: View {
    
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var alertInfo: AlertInfo?

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.expenses.isEmpty && viewModel.isBusy {
                    Text("Loading...")
                        .font(.largeTitle)
                } else if viewModel.expenses.isEmpty {
                    Text("Nothing Found")
                        .font(.largeTitle)
                } else {
                    List(viewModel.expenses, id: \.paid) { expense in
                        NavigationLink {
                            ExpenseItemsView(expense: expense)
                        } label: {
                            ExpenseRow(expense: expense)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(.init())
                    }
                    .listStyle(.plain)
                    .padding(.trailing)
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchExpenses()
                    } catch let urlError as URLError {
                        alertInfo = self.alertInfo(for: urlError)
                    } catch let decodingError as DecodingError {
                        alertInfo = AlertInfo(message: " JSON Parse Error: \(decodingError)")
                    }
                }
            }
            .alert(item: $alertInfo) { info in
                Alert(
                    title: Text("Network Error"),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Expenses")
        }
    }
    
    // MARK: - Helpers
    
    private func alertInfo(for urlError: URLError) -> AlertInfo {
        switch urlError.code {
        case .badURL:
            return AlertInfo(message: "Invalid Request URL.")
        case .badServerResponse:
            return AlertInfo(message: "The server returned an invalid response.")
        default:
            return AlertInfo(message: "\(urlError)")
        }
    }
}


// MARK: - List Row

struct ExpenseRow: View {
    
    var expense: Expense

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                TopLeadingCornerTriangle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(expense.color)
                Spacer()
            }
            Text(expense.shop)
            Spacer()
            Text(expense.dollarAmount)
                .padding()
        }
    }
}


// MARK: - AlertInfo

private struct AlertInfo: Identifiable {
    let id = UUID()
    let message: String
}



#Preview {
    ExpensesView()
}
