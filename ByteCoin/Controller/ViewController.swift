//
//  ViewController.swift
//  ByteCoin
//
//  Created by Vahe Aslanyan on 5/5/20.
//  Copyright © 2020 Vahe Aslanyan. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIPickerViewDataSource {
    var coinManager = CoinManager()

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }

}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, valueInCurrency: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = valueInCurrency.rateString
            self.currencyLabel.text = valueInCurrency.currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
