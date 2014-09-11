//
//  ProfitView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/31/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ProfitView: UIView {

    var decorationLabel: UILabel!
    var riskLabel: UILabel!

    var shareTitleLabel: UILabel!
    var shareLabel: UILabel!

    var totalTitleLabel: UILabel!
    var totalLabel: UILabel!

    class var defaultHeight: CGFloat {
        get {
            return 60.0
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        decorationLabel = UILabel(frame: CGRectZero)
        decorationLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        decorationLabel.backgroundColor = UIColor.clearColor()
        decorationLabel.textColor = UIColor.blackColor()
        decorationLabel.font = UIFont(name: "Verdana-Bold", size: 20.0)
        decorationLabel.textAlignment = .Center
        decorationLabel.minimumScaleFactor = 14.0 / 20.0
        decorationLabel.adjustsFontSizeToFitWidth = true

        decorationLabel.autoSetDimensionsToSize(CGSizeMake(65.0, 24.0))

        self.addSubview(decorationLabel)

        riskLabel = UILabel(frame: CGRectZero)
        riskLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskLabel.backgroundColor = UIColor.clearColor()
        riskLabel.font = UIFont.systemFontOfSize(12.0)
        riskLabel.textColor = Color.text
        riskLabel.minimumScaleFactor = 9.0 / 12.0
        riskLabel.adjustsFontSizeToFitWidth = true
        riskLabel.textAlignment = .Center

        self.addSubview(riskLabel)

        shareTitleLabel = UILabel(frame: CGRectZero)
        shareTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        shareTitleLabel.backgroundColor = UIColor.clearColor()
        shareTitleLabel.font = UIFont.systemFontOfSize(12.0)
        shareTitleLabel.textColor = Color.text
        shareTitleLabel.textAlignment = .Left

        self.addSubview(shareTitleLabel)

        shareLabel = UILabel(frame: CGRectZero)
        shareLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        shareLabel.backgroundColor = UIColor.clearColor()
        shareLabel.font = UIFont.systemFontOfSize(14.0)
        shareLabel.minimumScaleFactor = 9.0 / 14.0
        shareLabel.adjustsFontSizeToFitWidth = true
        shareLabel.textColor = UIColor.blackColor()
        shareLabel.textAlignment = .Right

        shareLabel.autoSetDimension(.Width, toSize: 120.0)

        self.addSubview(shareLabel)

        totalTitleLabel = UILabel(frame: CGRectZero)
        totalTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        totalTitleLabel.backgroundColor = UIColor.clearColor()
        totalTitleLabel.font = UIFont.systemFontOfSize(12.0)
        totalTitleLabel.textColor = Color.text
        totalTitleLabel.textAlignment = .Left

        self.addSubview(totalTitleLabel)

        totalLabel = UILabel(frame: CGRectZero)
        totalLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        totalLabel.backgroundColor = UIColor.clearColor()
        totalLabel.font = UIFont.systemFontOfSize(14.0)
        totalLabel.minimumScaleFactor = 9.0 / 14.0
        totalLabel.adjustsFontSizeToFitWidth = true
        totalLabel.textColor = UIColor.blackColor()
        totalLabel.textAlignment = .Right

        totalLabel.autoSetDimension(.Width, toSize: 120.0)

        self.addSubview(totalLabel)
    }

    override func updateConstraints() {
        decorationLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        decorationLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)

        riskLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        riskLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: decorationLabel)
        riskLabel.autoPinEdge(.Left, toEdge: .Left, ofView: decorationLabel)

        shareTitleLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: shareLabel)
        shareTitleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: decorationLabel, withOffset: 10.0)

        shareLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        shareLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        totalTitleLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: totalLabel)
        totalTitleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: shareTitleLabel)

        totalLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        totalLabel.autoPinEdge(.Right, toEdge: .Right, ofView: shareLabel)

        super.updateConstraints()
    }

}
