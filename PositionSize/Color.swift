//
//  Color.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

struct Color {
    static var green: UIColor {
        return UIColor.colorWithHex(0x4CD964)
    }

    static var orange: UIColor {
        return UIColor.colorWithHex(0xF57900)
    }

    static var red: UIColor {
        return UIColor.colorWithHex(0xEF2929)
    }

    static var ultraLightGray: UIColor {
        return UIColor.colorWithHex(0xD3D7CF)
    }

    static var lightGray: UIColor {
        return UIColor.colorWithHex(0xBABDB6)
    }

    static var gray: UIColor {
        return UIColor.colorWithHex(0x888A85)
    }

    static var darkGray: UIColor {
        return UIColor.colorWithHex(0x2E3436)
    }

    static var purple: UIColor {
        return UIColor.colorWithHex(0x5C3566)
    }

    static var highlight: UIColor {
        return purple
    }

    static var border: UIColor {
        return ultraLightGray
    }

    static var text: UIColor {
        return gray
    }
}