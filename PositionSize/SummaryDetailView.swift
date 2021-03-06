//
//  SummaryDetailView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/18/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class SummaryDetailView: UIView {

    var titleLabel: UILabel!

    var leftTextLabel: UILabel!
    var leftDetailLabel: UILabel!

    var rightTextLabel: UILabel!
    var rightDetailLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(17.0)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center

        self.addSubview(titleLabel)

        leftTextLabel = SummaryDetailView.textLabel()
        leftTextLabel.textAlignment = .Left

        leftTextLabel.autoSetDimension(.Width, toSize: 100.0)

        self.addSubview(leftTextLabel)

        leftDetailLabel = SummaryDetailView.detailLabel()
        leftDetailLabel.textAlignment = .Left
        self.addSubview(leftDetailLabel)

        rightTextLabel = SummaryDetailView.textLabel()
        rightTextLabel.textAlignment = .Right
        self.addSubview(rightTextLabel)

        rightDetailLabel = SummaryDetailView.detailLabel()
        rightDetailLabel.textAlignment = .Right
        self.addSubview(rightDetailLabel)
    }

    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        titleLabel.autoAlignAxisToSuperviewAxis(.Vertical)

        leftDetailLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20.0)
        leftDetailLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        leftTextLabel.autoPinEdge(.Left, toEdge: .Left, ofView: leftDetailLabel)
        leftTextLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: leftDetailLabel, withOffset: 0.0)

        rightDetailLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20.0)
        rightDetailLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        rightTextLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        rightTextLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: leftTextLabel)

        rightTextLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: leftTextLabel, withMultiplier: 1.75)

        super.updateConstraints()
    }

    // MARK: - Private Methods

    private class func textLabel() -> UILabel! {
        var label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(28.0)
        label.minimumScaleFactor = 12.0 / 28.8
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.darkGrayColor()

        return label
    }

    private class func detailLabel() -> UILabel! {
        var label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()

        return label
    }
    
}
