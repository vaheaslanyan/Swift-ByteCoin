//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Vahe Aslanyan on 5/5/20.
//  Copyright © 2020 Vahe Aslanyan. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let currency: String
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
