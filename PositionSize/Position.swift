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

    init() {
        accountSize = NSDecimalNumber(double: 10000.0)
    }

    var isReady: Bool {
        get {
            return !accountSize.isEqualToZero() && !riskPercentage.isEqualToZero() && !maxPositionSize.isEqualToZero() && !entryPrice.isEqualToZero() && !stopPrice.isEqualToZero()
        }
    }

    var isPartiallyReady: Bool {
        get {
            return !accountSize.isEqualToZero() && !riskPercentage.isEqualToZero() && !maxPositionSize.isEqualToZero()
        }
    }

    var isValid: (valid: Bool, errorMessage: String!) {
        get {
            var  error = false
            var string: String!

            let entry = entryPrice
            let stop = stopPrice

            if entry.isEqualToZero() || stop.isEqualToZero() {
                return (true, nil)
            }

            if entry.isEqualToDecimalNumber(stop) {
                error = true
                string = "Entry Price and Stop Loss Price cannot be the same."
            }

            if !error {
                if tradeType == TradeType.Long {
                    if entry.isLessThanDecimalNumber(stop) {
                        error = true
                        string = "In Long positions the Stop Loss Price should be below the Entry Price."
                    }
                } else {
                    if entry.isGreaterThanDecimalNumber(stop) {
                        error = true
                        string = "In Short positions the Stop Loss Price should be above the Entry Price."
                    }
                }
            }

            return (!error, string)
        }
    }

    var isApproved: Bool {
        get {
            let ready = isReady

            if !ready {
                return false
            }

            let positionSize = maxPositionSizeTotal()
            let investment = totalInvestment()

            if positionSize == nil || investment == nil {
                return false
            }

            let shares = numberOfShares()

            if shares == nil || shares.isEqualToZero() {
                return false
            }

            println("total investment: \(investment)")

            return investment.isLessThanOrEqualToDecimalNumber(positionSize)
        }
    }

    func tradeTypeString() -> String! {
        if entryPrice.isEqualToZero() {
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
        return accountSize.isEqualToZero() ? "Tap to Enter Your Account Size" : accountSize.currencyString()
    }

    func riskPercentageString() -> String {
        return riskPercentage.isEqualToZero() ? "Select" : riskPercentage.percentString()
    }

    func maxPositionSizeString() -> String {
        return maxPositionSize.isEqualToZero() ? "Select" : maxPositionSize.percentString()
    }

    func maxPositionSizeTotal() -> NSDecimalNumber! {
        if accountSize.isEqualToZero() || maxPositionSize.isEqualToZero() {
            return nil
        }

        return accountSize.decimalNumberByMultiplyingBy(maxPositionSize)
    }

    func maxPositionSizeTotalString() -> String! {
        let total = maxPositionSizeTotal()
        return total == nil ? nil : total.currencyString()
    }

    func entryPriceString() -> String {
        return entryPrice.isEqualToZero() ? "Select" : entryPrice.currencyString()
    }

    func stopPriceString() -> String {
        return stopPrice.isEqualToZero() ? "Select" : stopPrice.currencyString()
    }

    // MARK: - Calculations

    func riskAmount() -> NSDecimalNumber! {
        if accountSize.isEqualToZero() || riskPercentage.isEqualToZero() {
            return nil
        }

        return accountSize.decimalNumberByMultiplyingBy(riskPercentage)
    }

    func riskAmountString() -> String! {
        let amount = riskAmount()
        return amount == nil ? nil : "Risk = \(amount.currencyString())"
    }

    func riskAmountAttributedString() -> NSAttributedString! {
        let string: NSString! = riskAmountString() as NSString!

        if string == nil {
            return nil
        }

        var attributedString = NSMutableAttributedString(string: string)

        if let risk = riskAmount() {
            let riskStr = risk.currencyString()
            let range = string.rangeOfString(riskStr)

            let color = risk.isLessThanDecimalNumber(NSDecimalNumber.zero()) ? Color.red : Color.header

            let attributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(11.0),
                NSForegroundColorAttributeName : color
            ]

            attributedString.addAttributes(attributes, range: range)
        }
        
        return attributedString
    }

    func riskPerShare() -> NSDecimalNumber! {
        if entryPrice.isEqualToZero() || stopPrice.isEqualToZero() {
            return nil
        }

        if entryPrice.isEqualToDecimalNumber(stopPrice) {
            return nil
        }

        var risk: NSDecimalNumber!

        switch tradeType {
        case .Long:
            risk = entryPrice.decimalNumberBySubtracting(stopPrice)
        case .Short:
            risk = stopPrice.decimalNumberBySubtracting(entryPrice)
        default:
            risk = nil
        }

        return risk
    }

    func riskPerShareString() -> String! {
        let risk = riskPerShare()
        return risk == nil ? nil : "1R = \(risk.currencyString())"
    }

    func riskPerShareAttributedString() -> NSAttributedString! {
        let string: NSString! = riskPerShareString() as NSString!

        if string == nil {
            return nil
        }

        var attributedString = NSMutableAttributedString(string: string)

        if let risk = riskPerShare() {
            let riskStr = risk.currencyString()
            let range = string.rangeOfString(riskStr)

            let color = risk.isLessThanDecimalNumber(NSDecimalNumber.zero()) ? Color.red : Color.header

            let attributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(11.0),
                NSForegroundColorAttributeName : color
            ]

            attributedString.addAttributes(attributes, range: range)
        }

        return attributedString
    }

    func numberOfShares() -> NSDecimalNumber! {
        let risk = riskPerShare()
        let amount = riskAmount()

        if risk == nil || amount == nil {
            return nil
        }

        let roundingMode = NSRoundingMode.RoundDown

        var handler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: 0,
            raiseOnExactness: true,
            raiseOnOverflow: true,
            raiseOnUnderflow: true,
            raiseOnDivideByZero: true)

        let shares = amount.decimalNumberByDividingBy(risk, withBehavior: handler)
        println("shares: \(shares)")

        return shares
    }

    func numberOfSharesString() -> String! {
        let shares = numberOfShares()
        return shares == nil ? "0" : shares.stringValue
    }

    func allowedNumberOfShares() -> NSDecimalNumber! {
        let approved = isApproved

        if approved {
            return nil
        }

        if entryPrice.isEqualToZero() {
            return nil
        }

        let positionSize = maxPositionSizeTotal()

        let roundingMode = NSRoundingMode.RoundDown

        var handler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: 0,
            raiseOnExactness: true,
            raiseOnOverflow: true,
            raiseOnUnderflow: true,
            raiseOnDivideByZero: false)

        let shares = positionSize.decimalNumberByDividingBy(entryPrice, withBehavior: handler)
        println("allowed shares: \(shares)")

        return shares
    }

    func allowedNumberOfSharesString() -> String! {
        let shares = allowedNumberOfShares()
        return shares == nil ? "0" : shares.stringValue
    }

    func totalInvestment() -> NSDecimalNumber! {
        if entryPrice.isEqualToZero() {
            return nil
        }

        let shares = numberOfShares()

        if shares == nil {
            return nil
        }

        return shares.decimalNumberByMultiplyingBy(entryPrice)
    }

    func totalInvestmentString() -> String! {
        let total = totalInvestment()
        return total == nil ? "0" : total.currencyString()
    }

    func allowedTotalInvestment() -> NSDecimalNumber! {
        if entryPrice.isEqualToZero() {
            return nil
        }

        let shares = allowedNumberOfShares()

        if shares == nil {
            return nil
        }

        return shares.decimalNumberByMultiplyingBy(entryPrice)
     }

    func allowedTotalInvestmentString() -> String! {
        let total = allowedTotalInvestment()
        return total == nil ? "0" : total.currencyString()
    }

    func allowedRisk() -> NSDecimalNumber! {
        let risk = riskPerShare()
        let shares = allowedNumberOfShares()

        if risk == nil || shares == nil {
            return nil
        }

        return risk.decimalNumberByMultiplyingBy(shares)
    }

    func allowedRiskString() -> String! {
        let risk = allowedRisk()
        return risk == nil ? NSDecimalNumber.zero().currencyString() : risk.currencyString()
    }

    func allowedRiskPercentage() -> NSDecimalNumber! {
        let risk = allowedRisk()
        let totalRisk = riskAmount()

        if risk == nil || totalRisk == nil {
            return nil
        }

        return risk.decimalNumberByDividingBy(totalRisk)
    }

    func allowedRiskPercentageString() -> String! {
        let percent = allowedRiskPercentage()
        return percent == nil ? NSDecimalNumber.zero().percentString() : percent.percentString()
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
        //accountSize = NSDecimalNumber.zero()
        // riskPercentage = NSDecimalNumber.zero()
        // maxPositionSize = NSDecimalNumber.zero()
        entryPrice = NSDecimalNumber.zero()
        stopPrice = NSDecimalNumber.zero()
    }
    
}
