//
//  Position.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/24/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class Position {
    var tradeType: TradeType = .Long
    var accountSize: NSDecimalNumber = NSDecimalNumber.zero()
    var riskPercentage: NSDecimalNumber = NSDecimalNumber.zero()
    var maxPositionSize: NSDecimalNumber = NSDecimalNumber.zero()
    var entryPrice: NSDecimalNumber = NSDecimalNumber.zero()
    var stopPrice: NSDecimalNumber = NSDecimalNumber.zero()

    func tradeTypeString() -> String! {
        if entryPrice == NSDecimalNumber.zero() {
            return nil
        }

        var string: String!

        switch tradeType {
        case .Long:
            string = "Long"
        case .Short:
            string = "Short"
        default:
            string = nil
        }

        return string
    }

    // MARK: - Account

    func accountSizeString() -> String {
        return accountSize == NSDecimalNumber.zero() ? "Tap to Enter Your Account Size" : accountSize.currencyString()
    }

    // MARK: - Risk

    func riskPercentageString() -> String {
        return riskPercentage == NSDecimalNumber.zero() ? "Select" : riskPercentage.percentString()
    }

    func riskPercentageTotal() -> NSDecimalNumber! {
        if accountSize == NSDecimalNumber.zero() || riskPercentage == NSDecimalNumber.zero() {
            return nil
        }

        return accountSize.decimalNumberByMultiplyingBy(riskPercentage)
    }

    func riskPercentageTotalString() -> String! {
        let total = riskPercentageTotal()
        return total == nil ? nil : total.currencyString()
    }

    func riskTotal() -> NSDecimalNumber! {
        if entryPrice == NSDecimalNumber.zero() || stopPrice == NSDecimalNumber.zero() {
            return nil
        }

        var total: NSDecimalNumber!

        switch tradeType {
        case .Long:
            total = entryPrice.decimalNumberBySubtracting(stopPrice)
        case .Short:
            total = stopPrice.decimalNumberBySubtracting(entryPrice)
        default:
            total = nil
        }

        return total
    }

    func riskTotalString() -> String! {
        let total = riskTotal()
        return total == nil ? nil : "1R = \(total.currencyString())"
    }

    // MARK: - Maximum Position

    func maxPositionSizeString() -> String {
        return maxPositionSize == NSDecimalNumber.zero() ? "Select" : maxPositionSize.singlePercentString()
    }

    func maxPositionSizeTotal() -> NSDecimalNumber! {
        if accountSize == NSDecimalNumber.zero() || maxPositionSize == NSDecimalNumber.zero() {
            return nil
        }

        return accountSize.decimalNumberByMultiplyingBy(maxPositionSize)
    }

    func maxPositionSizeTotalString() -> String! {
        let total = maxPositionSizeTotal()
        return total == nil ? nil : total.currencyString()
    }

    // MARK: - Entry Price

    func entryPriceString() -> String {
        return entryPrice == NSDecimalNumber.zero() ? "Select" : entryPrice.currencyString()
    }

    // MARK: - Stop Price

    func stopPriceString() -> String {
        return stopPrice == NSDecimalNumber.zero() ? "Select" : stopPrice.currencyString()
    }

    // MARK: -

    func updateValuesForTraderProfile(profile: TraderProfile) {
        switch profile {
        case .Aggressive:
            riskPercentage = NSDecimalNumber(double: 0.02)
            maxPositionSize = NSDecimalNumber(double: 0.2)
        case .Moderate:
            riskPercentage = NSDecimalNumber(double: 0.015)
            maxPositionSize = NSDecimalNumber(double: 0.15)
        case .Conservative:
            riskPercentage = NSDecimalNumber(double: 0.01)
            maxPositionSize = NSDecimalNumber(double: 0.1)
        default:
            riskPercentage = NSDecimalNumber.zero()
            maxPositionSize = NSDecimalNumber.zero()
        }
    }

    func resetValues() {
        tradeType = .Long
        accountSize = NSDecimalNumber.zero()
        riskPercentage = NSDecimalNumber.zero()
        maxPositionSize = NSDecimalNumber.zero()
        entryPrice = NSDecimalNumber.zero()
        stopPrice = NSDecimalNumber.zero()
    }
    
}
