//
//  SummaryMessageView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/28/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class SummaryMessageView: UIView {

    var titleLabel: UILabel!
    var textLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(20.0)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center

        self.addSubview(titleLabel)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.systemFontOfSize(16.0)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textColor = UIColor.blackColor()
        textLabel.numberOfLines = 3

        textLabel.autoSetDimension(.Width, toSize: 280.0)

        self.addSubview(textLabel)
    }

    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        titleLabel.autoAlignAxisToSuperviewAxis(.Vertical)

        textLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 10.0)
        textLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        super.updateConstraints()
    }

}
