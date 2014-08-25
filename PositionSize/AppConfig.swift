//
//  Settings.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

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

class AppConfig {
    struct Config {
        static let traderProfileKey = "TraderProfileKey"
    }

    class func defaultTraderProfile() -> TraderProfile {
        var profileStr: NSString! = NSUserDefaults.standardUserDefaults().objectForKey(Config.traderProfileKey) as NSString!

        if profileStr == nil {
            profileStr = TraderProfile.Conservative.toRaw()
        }

        let defaultProfile = TraderProfile.fromRaw(profileStr)

        return defaultProfile!
    }

    class func setDefaultTraderProfile(profile: TraderProfile) {
        NSUserDefaults.standardUserDefaults().setObject(profile.toRaw(), forKey: Config.traderProfileKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    class func indexForCurrentTraderProfile() -> Int {
        return AppConfig.indexForTraderProfile(AppConfig.defaultTraderProfile())
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
