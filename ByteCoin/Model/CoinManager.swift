//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Vahe Aslanyan on 5/5/20.
//  Copyright © 2020 Vahe Aslanyan. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, valueInCurrency: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(EV.API.coinAPI)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
            }
            
                if let safeData = data {
                    if let valueInCurrency = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, valueInCurrency: valueInCurrency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let rate = decodedData.rate
            let currency = decodedData.asset_id_quote
            
            let valueInCurrency = CoinModel(rate: rate, currency: currency)
            return valueInCurrency
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
