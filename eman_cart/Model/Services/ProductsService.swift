//
//  ProductsService.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class ProductsService {
    static let shared = ProductsService()
    
    private var cachedProducts: [Product]?
    
    private func loadProducts() {
        guard let productsJsonFile = Bundle.main.path(forResource: "Products", ofType: "json") else { fatalError("Can't find Products.json in bundle.") }
        
        do {
            let productsJson = try Data(contentsOf: URL(fileURLWithPath: productsJsonFile))
            let products = try JSONDecoder().decode([Product].self, from: productsJson)
            
            cachedProducts = products
        } catch(let error) {
            fatalError(error.localizedDescription)
        }
    }
    
    func all() -> [Product] {
        if cachedProducts == nil {
            loadProducts()
        }
        
        // We can be certain that the array is correctly loaded (we already handled all possible errors), that's why I'm using force unwrap
        return cachedProducts!
    }
    
    func product(id: Int) -> Product? {
        if cachedProducts == nil {
            loadProducts()
        }
        
        if let index = cachedProducts!.index(where: { $0.id == id }) {
            return cachedProducts![index]
        }
        
        return nil
    }
}
