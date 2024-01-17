//
//  ViewController.swift
//  ByteCoin
//
//  Created by Badal  Aryal on 17/01/2024.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController  {
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    var coinManager = CoinManager()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
   
}
//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate{
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpatePrice(price: String, currency: String) {
       
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
        
    }
}
//MARK: - UIPickerViewDelegate

extension CoinViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}
//MARK: - UIPickerViewDataSource

extension CoinViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}
