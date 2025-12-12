//
//  Utilities.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import Foundation

class Utilities {
    
    static func printPrettyJSON(_ data: Data) {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes])
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                print("\n===== JSON Response =====\n\(prettyString)\n==========================\n")
            } else {
                print("[PrettyPrint] Unable to encode JSON to UTF-8 string.")
            }
        } catch {
            if let raw = String(data: data, encoding: .utf8) {
                print("[PrettyPrint] Failed to pretty print JSON. Error: \(error)\nRaw response: \n\(raw)")
            } else {
                print("[PrettyPrint] Failed to pretty print JSON and could not decode raw data as UTF-8. Error: \(error)")
            }
        }
    }
}
