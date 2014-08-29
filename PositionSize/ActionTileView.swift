//
//  ActionTileView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/24/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ActionTileView: UIControl {

    struct Config {
        static let padding: CGFloat = 2.0
        static let verticalPadding: CGFloat = 8.0
    }

    let headerLabel: UILabel!
    let textLabel: UILabel!
    let footerLabel: UILabel!

    override var highlighted: Bool {
        didSet {
            if highlighted {
                self.backgroundColor = Color.highlight.colorWithAlphaComponent(0.1)
            } else {
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        headerLabel = UILabel(frame: CGRectZero)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.textAlignment = .Center
        headerLabel.font = UIFont.systemFontOfSize(11.0)
        headerLabel.minimumScaleFactor = 9.0 / 11.0
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.textColor = Color.header

        self.addSubview(headerLabel)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.font = UIFont.systemFontOfSize(26.0)
        textLabel.textAlignment = .Center
        textLabel.minimumScaleFactor = 12.0 / 26.0;
        textLabel.adjustsFontSizeToFitWidth = true;
        textLabel.textColor = Color.highlight
        textLabel.text = "Select"

        self.addSubview(textLabel)

        footerLabel = UILabel(frame: CGRectZero)
        footerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        footerLabel.textAlignment = .Center
        footerLabel.font = UIFont.systemFontOfSize(12.0)
        footerLabel.minimumScaleFactor = 9.0 / 12.0
        footerLabel.adjustsFontSizeToFitWidth = true
        footerLabel.backgroundColor = UIColor.clearColor()
        footerLabel.textColor = Color.text

        self.addSubview(footerLabel)
    }

    override func updateConstraints() {
        textLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        textLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: Config.padding)
        textLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: Config.padding)

        headerLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: textLabel, withOffset: -Config.verticalPadding)
        headerLabel.autoPinEdge(.Left, toEdge: .Left, ofView: textLabel)
        headerLabel.autoPinEdge(.Right, toEdge: .Right, ofView: textLabel)

        footerLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: textLabel, withOffset: Config.verticalPadding)
        footerLabel.autoPinEdge(.Left, toEdge: .Left, ofView: textLabel)
        footerLabel.autoPinEdge(.Right, toEdge: .Right, ofView: textLabel)

        super.updateConstraints()
    }

}
