//
//  CartViewModel.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 24/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class CartViewModel: NSObject {
    var data: [CartService.CartItem] {
        return CartService.shared.all()
    }
    
    var currency = CurrenciesService.shared.find(key: "USD")
}
