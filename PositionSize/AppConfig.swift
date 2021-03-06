//
//  Settings.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

struct Analytics {
    static let devKey = "MCYJNPYXQYH5QWMNPBBF"
    static let productionKey = "K9G92V2NHD55GMG5HJRK"
}

struct AnalyticsKeys {
    static let enableCommissions = "Enable Commissions"
    static let disableCommissions = "Disable Commissions"
    static let updateRMultiple = "Update R-Multiple"
    static let updateTradingStyle = "Update Trading Style"
    static let resetTradingStyle = "Reset Trading Style"
    static let selectTradingStyle = "Select Trading Style"
    static let updateAccountBalance = "Update Account Balance"
    static let updateRiskPercentage = "Update Risk Percent"
    static let updateMaximumPositionSize = "Update Maximum Position Size"
    static let updateEntryPrice = "Update Entry Price"
    static let updateStopLossPrice = "Update Stop Loss Price"
    static let resetPosition = "Reset Position"
    static let resetToInitialValue = "Reset to Initial Value"
    static let selectProfitLoss = "Select Profit Loss"
    static let selectSettings = "Select Settings"
    static let selectGeneralGuide = "Select General Guide"
}

enum TradeType {
    case None
    case Long
    case Short
}

enum TraderProfile: String {
    case Aggressive = "TraderProfileAggressive"
    case Moderate = "TraderProfileModerate"
    case Conservative = "TraderProfileConservative"
}

struct AppDefaults {
    static let traderProfile: TraderProfile = .Conservative
    static let enableCommissions: Bool = false
    static let aggressiveRiskPercentage: Double = 0.02
    static let aggressivePositionSize: Double = 0.25
    static let moderateRiskPercentage: Double = 0.01
    static let moderatePositionSize: Double = 0.25
    static let conservativeRiskPercentage: Double = 0.005
    static let conservativePositionSize: Double = 0.25
    static let profitLossRMultiple: Double = 10
}

struct UserKeys {
    static let accountSize = "PSUserKeysAccountSize"
    static let entryPrice = "PSUserKeysEntryPrice"
    static let stopPrice = "PSUserKeysStopPrice"
    static let traderProfile = "PSUserKeysTraderProfile"
    static let enableCommissions = "PSUserKeysEnableCommissions"
    static let entryCommission = "PSUserKeysEntryCommission"
    static let exitCommission = "PSUserKeysExitCommission"
    static let aggressiveRiskPercentage = "PSUserKeyAggressiveRiskPercentage"
    static let aggressivePositionSize = "PSUserKeyAggressivePositionSize"
    static let moderateRiskPercentage = "PSUserKeyModerateRiskPercentage"
    static let moderatePositionSize = "PSUserKeyModeratePositionSize"
    static let conservativeRiskPercentage = "PSUserKeyConservativeRiskPercentage"
    static let conservativePositionSize = "PSUserKeyConservativePositionSize"
    static let profitLossRMultiple = "PSUserKeyProfitLossRMultiple"
}

struct URLStrings {
    static let guide = "http://chartingninja.com/apps/trade_size/guide"
}

class AppConfig {

    class var userDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }

    class func setUserDefaultValue(value: AnyObject!, forKey: String) {
        if let tmp: AnyObject = value {
            userDefaults.setObject(tmp, forKey: forKey)
        } else {
            userDefaults.removeObjectForKey(forKey)
        }

        userDefaults.synchronize()
    }

    // MARK: - Standard User Defaults

    class var accountSize: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.accountSize) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
                if number.isLessThanDecimalNumber(NSDecimalNumber.zero()) {
                    number = NSDecimalNumber.zero()
                }
            } else {
                number = NSDecimalNumber.zero()
            }

            return number
        }

        set (newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.accountSize)
        }
    }

    class var defaultTraderProfile: TraderProfile {
        get {
            var string: String!

            if let tmp = userDefaults.objectForKey(UserKeys.traderProfile) as AnyObject! as String! {
                string = tmp
            } else {
                string = AppDefaults.traderProfile.toRaw()
            }

            return TraderProfile.fromRaw(string)!
        }

        set(newValue) {
            setUserDefaultValue(newValue.toRaw(), forKey: UserKeys.traderProfile)
        }
    }

    class var enableCommisions: Bool {
        get {
            var number: NSNumber

            if let tmp = userDefaults.objectForKey(UserKeys.enableCommissions) as AnyObject! as NSNumber! {
                number = tmp
            } else {
                number = NSNumber(bool: AppDefaults.enableCommissions)
            }

            return number.boolValue
        }

        set(newValue) {
            setUserDefaultValue(NSNumber(bool: newValue), forKey: UserKeys.enableCommissions)
        }
    }

    class var entryCommission: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.entryCommission) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
                if number.isLessThanOrEqualToDecimalNumber(NSDecimalNumber.zero()) {
                    number = nil
                }
            }

            return number
        }

        set (newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.entryCommission)
        }
    }

    class var exitCommission: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.exitCommission) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
                if number.isLessThanOrEqualToDecimalNumber(NSDecimalNumber.zero()) {
                    number = nil
                }
            }

            return number
        }

        set (newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.exitCommission)
        }
    }

    class var aggressiveRiskPercentage: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.aggressiveRiskPercentage) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.aggressiveRiskPercentage)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue, forKey: UserKeys.aggressiveRiskPercentage)
        }
    }

    class var aggressivePositionSize: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.aggressivePositionSize) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.aggressivePositionSize)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.aggressivePositionSize)
        }
    }

    class var moderateRiskPercentage: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.moderateRiskPercentage) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.moderateRiskPercentage)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.moderateRiskPercentage)
        }
    }

    class var moderatePositionSize: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.moderatePositionSize) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.moderatePositionSize)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.moderatePositionSize)
        }
    }

    class var conservativeRiskPercentage: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.conservativeRiskPercentage) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.conservativeRiskPercentage)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.conservativeRiskPercentage)
        }
    }

    class var conservativePositionSize: NSDecimalNumber! {
        get {
            var number: NSDecimalNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.conservativePositionSize) as NSNumber! {
                number = NSDecimalNumber(double: tmp.doubleValue)
            } else {
                number = NSDecimalNumber(double: AppDefaults.conservativePositionSize)
            }

            return number
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.conservativePositionSize)
        }
    }

    class func valuesForTraderProfile(traderProfile: TraderProfile) -> (risk: NSDecimalNumber, size: NSDecimalNumber) {
        var risk: NSDecimalNumber
        var size: NSDecimalNumber

        switch traderProfile {
        case .Aggressive:
            risk = aggressiveRiskPercentage
            size = aggressivePositionSize
        case .Moderate:
            risk = moderateRiskPercentage
            size = moderatePositionSize
        case .Conservative:
            risk = conservativeRiskPercentage
            size = conservativePositionSize
        default:
            risk = NSDecimalNumber.zero()
            size = NSDecimalNumber.zero()
        }

        return (risk, size)
    }

    class var profitLossRMultiple: Double {
        get {
            var number: NSNumber!

            if let tmp = userDefaults.objectForKey(UserKeys.profitLossRMultiple) as NSNumber! {
                number = tmp
            } else {
                number = NSNumber(double: AppDefaults.profitLossRMultiple)
            }

            return number.doubleValue
        }

        set(newValue) {
            setUserDefaultValue(newValue as NSNumber!, forKey: UserKeys.profitLossRMultiple)
        }
    }

    // MARK: - Other Stuff

    class var totalCommissions: NSDecimalNumber {
        get {
            var commissions = NSDecimalNumber.zero()
            
            if AppConfig.enableCommisions {
                var entry = AppConfig.entryCommission
                if entry == nil {
                    entry = NSDecimalNumber.zero()
                }

                var exit = AppConfig.exitCommission
                if exit == nil {
                    exit = NSDecimalNumber.zero()
                }

                commissions = entry.decimalNumberByAdding(exit);
            }

            return commissions
        }
    }

    class func indexForCurrentTraderProfile() -> Int {
        return AppConfig.indexForTraderProfile(AppConfig.defaultTraderProfile)
    }

    class func titleForTraderProfile(profile: TraderProfile) -> String {
        var title: String
        switch profile {
        case .Aggressive:
            title = "Aggressive"
        case .Moderate:
            title = "Moderate"
        case .Conservative:
            title = "Conservative"
        default:
            title = "NONE"
        }
        return title
    }

    class func traderProfileForIndex(index: Int) -> TraderProfile {
        var profile: TraderProfile

        switch index {
        case 0:
            profile = .Aggressive
        case 1:
            profile = .Moderate
        case 2:
            profile = .Conservative
        default:
            profile = .Conservative
        }
        
        return profile
    }

    class func indexForTraderProfile(profile: TraderProfile) -> Int {
        var index: Int

        switch profile {
        case .Aggressive:
            index = 0
        case .Moderate:
            index = 1
        case .Conservative:
            index = 2
        default:
            index = 2
        }

        return index
    }
    
}
