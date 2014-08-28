//
//  CustomButton.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/27/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class CustomButton: UIControl {

    let textLabel: UILabel!

    override var highlighted: Bool {
        didSet {
            if highlighted {
                self.textLabel.textColor = Color.highlight.colorWithAlphaComponent(0.1)
            } else {
                self.textLabel.textColor = Color.highlight
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.font = UIFont.systemFontOfSize(36.0)
        textLabel.textColor = Color.highlight
        textLabel.minimumScaleFactor = 12.0 / 36.0
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .Center

        self.addSubview(textLabel)
    }

    override func updateConstraints() {
        textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0))
        super.updateConstraints()
    }

    func setTitle(title: String!) {
        textLabel.text = title
        self.setNeedsUpdateConstraints()
    }
    
}
