//
//  ProductsViewModel.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class ProductsViewModel: NSObject {
    var data: [Product] {
        return ProductsService.shared.all()
    }
    
    //TODO: implement currencies directly in product
    // By default, we show in USD, selection only available at checkout - USD must exist!
    var currency = CurrenciesService.shared.find(key: "USD") //CurrenciesService.shared.find(name: "USD")!
}
