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

private let currencyLayerRatesEndpoint = "http://www.apilayer.net/api/list?access_key=%@"
private let currencyLayerCurrenciesEndpoint = "http://www.apilayer.net/api/live?access_key=%@&format=1"

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
    
    //MARK: Cache to Memory
    private func cacheToMemory() {
        do {
            let currenciesJsonTemp = try String(contentsOf: currenciesJsonFile)
            let ratesJsonTemp = try String(contentsOf: ratesJsonFile)
            
            _ = loadCurrenciesAndRatesFromData(currenciesData: currenciesJsonTemp, ratesData: ratesJsonTemp)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    //MARK: Wants online update CurrencyLayer (CHECK REACHABILITY)
    private func wantsOnlineUpdate(){
        let currencyEndpoint = String(format: currencyLayerCurrenciesEndpoint, currencyLayerApiKey)
        let ratesEndpoint = String(format: currencyLayerRatesEndpoint, currencyLayerApiKey)
        var curenciesResponse: Any?
        var ratesResponse: Any?
        
        
        Alamofire.request(currencyEndpoint).responseJSON { response in
            if let json = response.result.value {
                curenciesResponse = json // serialized json response
            }
        }
        
        Alamofire.request(ratesEndpoint).responseJSON { response in
            if let json = response.result.value {
                ratesResponse = json // serialized json response
            }
        }
        
        //if this went through, update the Cache
        //TODO: make the responses in string
        if loadCurrenciesAndRatesFromData(currenciesData: curenciesResponse!, ratesData: ratesResponse!) {
            
        }
    }
    
    //MARK: CACHE UPDATE
    private func updateCache() {
        
    }
    
    // MARK: Cache and online (async) to Memory
    private func loadCurrencies() {
        //Bundle to Cache (we must have some data at the start)
        ensureCacheAvailable()
        
        // Load from cache
        cacheToMemory()
        
        // Want to load online
        if reachability.isReachable {
            //wantsOnlineUpdate()
        }
        
    }
    
    //MARK: Load to Memory from DataSource
    private func loadCurrenciesAndRatesFromData(currenciesData: Any, ratesData: Any) -> Bool {
        cachedCurrencies?.removeAll()
        cachedCurrencies = [String:Currency]()
        
//        guard let cDataFromString = currenciesData as? String
//            else {return false}
//
//
//        if let c1 = cDataFromString.data(using: .utf8, allowLossyConversion: false) {
//            let cJson = JSON(data: c1)
//        }
//
//
//        let rJson = JSON(ratesData)
        
//        guard let c1 = currenciesData as? [String:Any],
//            let currenciesDictionary = c1["currencies"] as? [String:String]
//            else { return false }
//
//        guard let r1 = ratesData as? [String:Any], let sourceCurrency = r1["source"] as? String,
//            let ratesDictionary = r1["quotes"] as? [String: Double]
//            else { return false }
//
//        for (key, value) in currenciesDictionary {
//            let rateKey = "\(sourceCurrency)\(key)"
//            guard let rate = ratesDictionary[rateKey] else { continue }
//            cachedCurrencies![key] = Currency(code: key, name: value, rate: rate)
//        }
        return true
    }
    
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
