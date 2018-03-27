//
//  Product.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

struct Product: Codable, Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var name: String
    var price: Double
    var imageAsset: String
    var unit: String
    
    //Currency can be computed directly in the Model (I can choose to display the price in different currencies whenever I choose to)
    func priceIn(currency: Currency, quantity: Int) -> String {
        return String(format: "%.2f %@", price * Double(quantity) * currency.rate, currency.code)
    }
}
