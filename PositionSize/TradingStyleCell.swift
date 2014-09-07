//
//  TradingStyleCell.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/1/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class TradingStyleCell: UITableViewCell {

    var titleLabel: UILabel!

    var riskTitleLabel: UILabel!
    var riskLabel: UILabel!

    var sizeTitleLabel: UILabel!
    var sizeLabel: UILabel!

    class var defaultHeight: CGFloat {
        get {
            return 78.0
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(reuseIdentifier: String!) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .Default
        self.accessoryType = .DisclosureIndicator
        self.opaque = true

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.highlightedTextColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Left

        self.contentView.addSubview(titleLabel)

        riskTitleLabel = UILabel(frame: CGRectZero)
        riskTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskTitleLabel.backgroundColor = UIColor.clearColor()
        riskTitleLabel.font = UIFont.systemFontOfSize(12.0)
        riskTitleLabel.textColor = Color.text
        riskTitleLabel.highlightedTextColor = UIColor.whiteColor()
        riskTitleLabel.textAlignment = .Left

        riskTitleLabel.text = "Risk Percent"

        riskTitleLabel.autoSetDimension(.Width, toSize: 160.0)

        self.contentView.addSubview(riskTitleLabel)

        riskLabel = UILabel(frame: CGRectZero)
        riskLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskLabel.backgroundColor = UIColor.clearColor()
        riskLabel.font = UIFont.systemFontOfSize(12.0)
        riskLabel.textColor = UIColor.blackColor()
        riskLabel.highlightedTextColor = UIColor.whiteColor()
        riskLabel.textAlignment = .Right

        riskLabel.autoSetDimension(.Width, toSize: 60.0)

        self.contentView.addSubview(riskLabel)

        sizeTitleLabel = UILabel(frame: CGRectZero)
        sizeTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        sizeTitleLabel.backgroundColor = UIColor.clearColor()
        sizeTitleLabel.font = UIFont.systemFontOfSize(12.0)
        sizeTitleLabel.textColor = Color.text
        sizeTitleLabel.highlightedTextColor = UIColor.whiteColor()
        sizeTitleLabel.textAlignment = .Left

        sizeTitleLabel.text = "Maximum Position Size"

        sizeTitleLabel.autoSetDimension(.Width, toSize: 160.0)

        self.contentView.addSubview(sizeTitleLabel)

        sizeLabel = UILabel(frame: CGRectZero)
        sizeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        sizeLabel.backgroundColor = UIColor.clearColor()
        sizeLabel.font = UIFont.systemFontOfSize(12.0)
        sizeLabel.textColor = UIColor.blackColor()
        sizeLabel.highlightedTextColor = UIColor.whiteColor()
        sizeLabel.textAlignment = .Right

        sizeLabel.autoSetDimension(.Width, toSize: 60.0)

        self.contentView.addSubview(sizeLabel)
    }

    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        sizeTitleLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        sizeTitleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: titleLabel)

        sizeLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: sizeTitleLabel)
        sizeLabel.autoPinEdge(.Right, toEdge: .Right, ofView: titleLabel)

        riskTitleLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: sizeTitleLabel, withOffset: -3.0)
        riskTitleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: sizeTitleLabel)

        riskLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: riskTitleLabel)
        riskLabel.autoPinEdge(.Right, toEdge: .Right, ofView: titleLabel)

        super.updateConstraints()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
