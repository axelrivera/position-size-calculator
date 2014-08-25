//
//  Currency.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/24/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

extension NSDecimalNumber {

    func currencyString() -> String {
        return NumberFormatter.currency.stringFromNumber(self)
    }

    func percentString() -> String {
        return NumberFormatter.percent.stringFromNumber(self)
    }

    func singlePercentString() -> String {
        return NumberFormatter.singlePercent.stringFromNumber(self)
    }

}