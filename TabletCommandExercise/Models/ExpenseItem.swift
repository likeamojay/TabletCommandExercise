//
//  ExpenseItem.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import Foundation

struct ExpenseItem: Codable {
    let name: String
    let ean: Int
    let price: Double

    private enum CodingKeys: String, CodingKey {
        case name, ean, price
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        
        if let intEan = try? container.decode(Int.self, forKey: .ean) {
            self.ean = intEan
        } else if let stringEan = try? container.decode(String.self, forKey: .ean),
                  let intFromString = Int(stringEan) {
            self.ean = intFromString
        } else {
            throw DecodingError.dataCorruptedError(forKey: .ean,
                                                   in: container,
                                                   debugDescription: "ean is not a string or an integer")
        }
    }
}
