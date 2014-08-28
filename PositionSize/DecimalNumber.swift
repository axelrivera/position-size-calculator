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

    func doublePercentString() -> String {
        return NumberFormatter.doubleDecimalPercent.stringFromNumber(self)
    }

    func isEqualToDecimalNumber(number: NSDecimalNumber) -> Bool {
        return self.isEqualToNumber(number)
    }

    func isGreaterThanDecimalNumber(number: NSDecimalNumber) -> Bool {
        return self.compare(number) == NSComparisonResult.OrderedDescending
    }

    func isLessThanDecimalNumber(number: NSDecimalNumber) -> Bool {
        return self.compare(number) == NSComparisonResult.OrderedAscending
    }

    func isGreaterThanOrEqualToDecimalNumber(number: NSDecimalNumber) -> Bool {
        return self.isGreaterThanDecimalNumber(number) || self.isEqualToDecimalNumber(number)
    }

    func isLessThanOrEqualToDecimalNumber(number: NSDecimalNumber) -> Bool {
        return self.isLessThanDecimalNumber(number) || self.isEqualToDecimalNumber(number)
    }

    func isEqualToZero() -> Bool {
        return self.isEqualToDecimalNumber(NSDecimalNumber.zero())
    }

}