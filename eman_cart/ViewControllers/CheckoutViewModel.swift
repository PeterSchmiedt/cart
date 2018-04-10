//
//  CheckoutViewModel.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 02/04/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class CheckoutViewModel: NSObject {
    var data: [CartService.CartItem] {
        return CartService.shared.all()
    }
    
    var currencies = CurrenciesService.shared.all()
    
    private func sum() -> Double {
        var sum: Double = 0
        for product in data {
            sum += product.item.price * Double(product.quantity)
        }
        return sum
    }
    
    func sumInCurrency(currencyKey: String) -> String {
        return String(format: "%.2f", sum() * CurrenciesService.shared.find(key: currencyKey)!.rate)
    }
}
