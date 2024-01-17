//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Badal  Aryal on 17/01/2024.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate{
    func didFailWithError(error: Error)
    func didUpatePrice(price:String, currency: String)
    
}

struct CoinManager {
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D96DFC08-B9A0-4EB2-BF8C-CA45A3FD7549"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    
    func getCoinPrice(for currency: String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                //Format the data we got back as a string
                if let safeData = data{
                    let bitcoinPrice = self.parseJSON(safeData)
                    let priceString = String(format: "%.2f", bitcoinPrice!)
                    self.delegate?.didUpatePrice(price: priceString, currency: currency)
                    
                }
                
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    
    
    func parseJSON(_ data: Data) -> Double?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
        
    }
}






