//
//  NumberFormatter.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/24/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

struct NumberFormatter {

    static var currency: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }

    static var doubleDecimalPercent: NSNumberFormatter {
    let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }

    static var percent: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }

    static var singlePercent: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
}