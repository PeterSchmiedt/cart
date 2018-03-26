//
//  Configuration.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 25/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation

class Configuration {
    static var main = Configuration()
    
    var currencyLayerApiKey: String
    init() {
        currencyLayerApiKey = Bundle.main.object(forInfoDictionaryKey: "CURRENCYLAYER_API_KEY") as! String
    }
}
