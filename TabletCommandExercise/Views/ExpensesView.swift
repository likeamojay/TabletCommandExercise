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
                        ExpenseRow(expense: expense)
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchExpenses()
                    } catch let urlError as URLError {
                        alertInfo = self.alertInfo(for: urlError)
                    } catch let decodingError as DecodingError {
                        alertInfo = AlertInfo(title: "JSON Parse Error", message: "\(decodingError)")
                    }
                }
            }
            .alert(item: $alertInfo) { info in
                Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Expenses")
            .padding()
        }
    }
    
    // MARK: - Helpers
    
    private func alertInfo(for urlError: URLError) -> AlertInfo {
        switch urlError.code {
        case .badURL:
            return AlertInfo(title: "Bad URL", message: "Invalid Request URL.")
        case .badServerResponse:
            return AlertInfo(title: "Server Error", message: "The server returned an invalid response.")
        default:
            return AlertInfo(title: "Error", message: "\(urlError)")
        }
    }
}

// MARK: - AlertInfo

private struct AlertInfo: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

#Preview {
    ExpensesView()
}
