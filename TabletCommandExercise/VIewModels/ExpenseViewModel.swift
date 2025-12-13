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
        isBusy = true
        defer { isBusy = false }
        
        if let savedExpenses = self.loadJSONFromDisk() {
            self.expenses = savedExpenses
            print("fetchExpense() - Loaded from disk")
            return
        }

        guard let url = URL(string: kUrl) else {
            print("fetchExpenses() - Invalid URL: \(kUrl)")
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //Utilities.printPrettyJSON(data)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("fetchExpenses() - Server error (status: \(httpResponse.statusCode))")
            throw URLError(.badServerResponse)
        }
        
        self.saveJSONtoDisk(data: data)

        do {
            let expenses = try decodeExpenses(from: data)
            self.expenses = expenses
        } catch let decoderError as DecodingError {
            print("JSON Parse error: \(decoderError)")
            throw decoderError
        }
    }
    
    // MARK: - Helpers
    
    private func decodeExpenses(from data: Data) throws -> [Expense] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Expense].self, from: data)
    }
    
    private func diskJSONUrl() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent("groceries.json")
    }
    
    private func loadJSONFromDisk() -> [Expense]? {
        guard let fileURL = self.diskJSONUrl() else { return nil }
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            let expenses = try decodeExpenses(from: data)
            return expenses
        } catch {
            print("loadJSONFromDisk() - Failed to load or decode groceries.json from disk: \(error)")
            return nil
        }
    }
    
    private func saveJSONtoDisk(data: Data) {
        guard let fileURL = self.diskJSONUrl() else {
            print("saveJSONtoDisk() - Failed to get Documents directory URL.")
            return
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("saveJSONtoDisk() - groceries.json already exists at: \(fileURL.path) Skipping save.")
            return
        }
        do {
            try data.write(to: fileURL, options: [.atomic])
            print("saveJSONtoDisk() - Saved groceries.json to: \(fileURL.path)")
        } catch {
            print("saveJSONtoDisk() - Failed to write groceries.json to disk: \(error)")
        }
    }
}

