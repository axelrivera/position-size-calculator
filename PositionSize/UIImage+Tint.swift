//
//  File.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

extension UIImage {

    func tintedImage(#color: UIColor) -> UIImage {
        return self.tintedImage(color: color, blendMode: kCGBlendModeDestinationIn)
    }

    func tintedImage(#color: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)

        color.setFill()

        let bounds = CGRectMake(0.0, 0.0, self.size.width, self.size.height)
        UIRectFill(bounds)

        self.drawInRect(bounds, blendMode: blendMode, alpha: 1.0)

        if blendMode.value != kCGBlendModeDestinationIn.value {
            self.drawInRect(bounds, blendMode: kCGBlendModeDestinationIn, alpha: 1.0)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }

    class func templateImage() -> UIImage {
        let size = CGSizeMake(1.0, 1.0)

        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)

        UIColor.blackColor().setFill()
        UIRectFill(CGRectMake(0.0, 0.0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image.imageWithRenderingMode(.AlwaysTemplate)
    }

    class func backgroundTemplateImage() -> UIImage {
        let insets = UIEdgeInsetsZero
        let image = UIImage.templateImage().resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Tile)
        return image.imageWithRenderingMode(.AlwaysTemplate)
    }

}