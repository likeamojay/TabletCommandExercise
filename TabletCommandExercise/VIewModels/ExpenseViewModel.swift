//
//  ExpenseViewModel.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import Combine
import Foundation

@MainActor
class ExpenseViewModel: ObservableObject {

    @Published var expenses: [Expense] = []
    @Published var isBusy = false
    
    private let kUrl = "https://review.tabletcommand.com/interview-mobile/groceries.json"

    func fetchExpenses() async throws {
        // Reset state
        isBusy = true
        defer { isBusy = false }
        
        // Build URL
        guard let url = URL(string: kUrl) else {
            print("Invalid URL: \(kUrl)")
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        Utilities.printPrettyJSON(data)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let message = "Server error (status: \(http.statusCode))"
            print(message)
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let expenses = try decoder.decode([Expense].self, from: data)
            self.expenses += expenses
        } catch let decoderError as DecodingError {
            print("JSON Parse error: \(decoderError)")
            throw decoderError
        }
    }
    
}
