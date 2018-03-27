//
//  CurrenciesService.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift
import SwiftyJSON
import Alamofire_SwiftyJSON

private let currencyLayerCurrenciesEndpoint = "http://www.apilayer.net/api/list?access_key=%@"
private let currencyLayerRatesEndpoint = "http://www.apilayer.net/api/live?access_key=%@&format=1"

private let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
private let currenciesJsonFile = URL(fileURLWithPath: cacheDirectory).appendingPathComponent("Currencies.json")
private let ratesJsonFile = URL(fileURLWithPath: cacheDirectory).appendingPathComponent("Rates.json")



class CurrenciesService {
    static let shared = CurrenciesService(currencyLayerApiKey: Configuration.main.currencyLayerApiKey)
    
    let currencyLayerApiKey: String
    
    let reachability = Reachability()!
    var lastFetchTime = Date(timeIntervalSince1970: 0)
    
    private var cachedCurrencies: [String: Currency]?
    
    init(currencyLayerApiKey: String) {
        self.currencyLayerApiKey = currencyLayerApiKey
    }
    
    //MARK: Bundle to Cache
    private func ensureCacheAvailable() {
        guard let currenciesJsonBundleFile = Bundle.main.path(forResource: "Currencies", ofType: "json")  else { fatalError("Can't find Currencies.json in bundle.") }
        guard let ratesJsonBundleFile = Bundle.main.path(forResource: "Rates", ofType: "json") else { fatalError("Can't find Rates.json in bundle.") }
        
        if !FileManager.default.fileExists(atPath: currenciesJsonFile.path) {
            try? FileManager.default.copyItem(at: URL(fileURLWithPath: currenciesJsonBundleFile), to: currenciesJsonFile)
        }
        
        if !FileManager.default.fileExists(atPath: ratesJsonFile.path) {
            try? FileManager.default.copyItem(at: URL(fileURLWithPath: ratesJsonBundleFile), to: ratesJsonFile)
        }
    }
    
    private func stringToJson(data: String) -> JSON {
        var json: JSON = JSON()
        if let dataFromString = data.data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("stringToJson - error creating JSON from String")
            }
        }
        return json
    }
    
    private func jsonToMemory(currenciesJSON: JSON, ratesJSON: JSON) {
        //Check if the response was OK
        if currenciesJSON["success"] == true && ratesJSON["success"] == true {
            cachedCurrencies?.removeAll()
            cachedCurrencies = [String:Currency]()
            
            let cJSON = currenciesJSON["currencies"]
            let rJSON = ratesJSON["quotes"]
            
            let sourceCurrency = ratesJSON["source"]
            
            for (key, value): (String, JSON) in cJSON {
                let rateKey = "\(sourceCurrency)\(key)"
                cachedCurrencies![key] = Currency(code: key, name: value.string!, rate: rJSON[rateKey].double!) //force unwrap
            }
        } else {
            print("jsonToMemory - success =! true")
        }
    }
    
    //MARK: Cache to Memory
    private func cacheToMemory() {
        
        do {
            let currenciesString = try String(contentsOf: currenciesJsonFile)
            let ratesString = try String(contentsOf: ratesJsonFile)

            let cJson = stringToJson(data: currenciesString)
            let rJson = stringToJson(data: ratesString)
            
            jsonToMemory(currenciesJSON: cJson, ratesJSON: rJson)
            
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    private func wantsOnlineUpdate(){
        //let currencyEndpoint = String(format: currencyLayerCurrenciesEndpoint, currencyLayerApiKey)
        let ratesEndpoint = String(format: currencyLayerRatesEndpoint, currencyLayerApiKey)
        
        Alamofire.request(ratesEndpoint).validate().responseSwiftyJSON { response in
            if((response.result.value) != nil) {
                let ratesJSON = JSON(response.result.value!)
                do {
                    let currenciesString = try String(contentsOf: currenciesJsonFile)
                    let currenciesCacheJson = self.stringToJson(data: currenciesString)
                    self.jsonToMemory(currenciesJSON: currenciesCacheJson, ratesJSON: ratesJSON)
                } catch {
                    print("wantsOnlineUpdate: \(error).")
                }
            } else {
                print("wantsOnlineUpdate - ratesRequest DENIED")
            }
        }
    }
    
    // MARK: Cache and online (async) to Memory-----------------------------------------------------------------------------------------------------
    private func loadCurrencies() {
        //Bundle to Cache (we must have some data at the start)
        ensureCacheAvailable()

        // Load from cache
        cacheToMemory()

        // Want to load online
        if reachability.isReachable {
            wantsOnlineUpdate()
        }

    }//------------------------------------------------------------------------------------------------------------------------------------------------
    
    func all() -> [String: Currency] {
        if (cachedCurrencies == nil) {
            loadCurrencies()
        }
        
        //All fails should be accounted for, use Force Unwrap
        return cachedCurrencies!
    }

    func find(key: String) -> Currency? {
        //return all().filter{ $0.name == name }.first
        return all()[key]
    }
    
    
}
