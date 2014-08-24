//
//  Button.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

extension UIButton {

    class func roundedButton(#color: UIColor) -> UIButton {
        let button: UIButton = UIButton.buttonWithType(.Custom) as UIButton

        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true

        let image = UIImage.backgroundTemplateImage().tintedImage(color: color)
        let disabledImage = UIImage.backgroundTemplateImage().tintedImage(color: Color.ultraLightGray)

        button.setBackgroundImage(image, forState: .Normal)
        button.setBackgroundImage(disabledImage, forState: .Highlighted)
        button.setBackgroundImage(disabledImage, forState: .Disabled)

        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.9), forState: .Highlighted)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.9), forState: .Disabled)

        return button
    }

}
