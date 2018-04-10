//
//  CartService.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 19/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class CartService {
    static let shared = CartService()
    
    class CartItem: Codable, Equatable {
        init(item: Product, quantity: Int) {
            self.item = item
            self.quantity = quantity
        }
        
        static func ==(lhs: CartItem, rhs: CartItem) -> Bool {
            return lhs.item == rhs.item
        }
        
        var item: Product
        var quantity: Int
        
        //MARK: price
    }
    
    private var cartItems = [CartItem]()
    
    func addProduct(product: Product) {
        itemForProduct(product: product).quantity += 1
    }
    
    func setProductQuantity(product: Product, quantity: Int) {
        itemForProduct(product: product).quantity = quantity
        cleanup()
    }
    
    // If nil, remove all
    func removeProduct(product: Product, quantity: Int? = nil) {
        if let quantity = quantity {
            itemForProduct(product: product).quantity -= quantity
        } else {
            let item = itemForProduct(product: product)
            item.quantity = 0
        }
        cleanup()
    }
    
    func all() -> [CartItem] {
        return cartItems
    }
    
    func removeAll() {
        cartItems.removeAll(keepingCapacity: false) //free memory
    }
    
    func count() -> Int {
        return cartItems.count
    }
    
    // MARK: Private
    private func itemForProduct(product: Product) -> CartItem {
        if let index = cartItems.index(where: { $0.item == product }) {
            return cartItems[index]
        } else {
            let cartItem = CartItem(item: product, quantity: 0)
            cartItems.append(cartItem)
            return cartItem
        }
    }
    
    private func cleanup() {
        cartItems = cartItems.filter({$0.quantity > 0})
    }
}
