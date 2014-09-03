//
//  StepperViewCell.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/2/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class StepperCell: UITableViewCell {

    var titleLabel: UILabel!
    var supportLabel: UILabel!
    var stepper: UIStepper!

    class var defaultHeight: CGFloat {
        get {
            return 66.0
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(reuseIdentifier: String!) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .None
        self.accessoryType = .None
        self.opaque = true

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.highlightedTextColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Left

        titleLabel.autoSetDimension(.Height, toSize: 18.0)

        self.contentView.addSubview(titleLabel)

        supportLabel = UILabel(frame: CGRectZero)
        supportLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        supportLabel.backgroundColor = UIColor.clearColor()
        supportLabel.font = UIFont.systemFontOfSize(22.0)
        supportLabel.textColor = Color.text
        supportLabel.highlightedTextColor = UIColor.whiteColor()
        supportLabel.textAlignment = .Left

        supportLabel.autoSetDimensionsToSize(CGSizeMake(200.0, 24.0))

        self.contentView.addSubview(supportLabel)

        stepper = UIStepper(frame: CGRectZero)
        stepper.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.contentView.addSubview(stepper)
        
    }

    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        titleLabel.autoPinEdge(.Right, toEdge: .Left, ofView: stepper, withOffset: -5.0)

        supportLabel.autoPinEdge(.Left, toEdge: .Left, ofView: titleLabel)
        supportLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: stepper)

        stepper.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        stepper.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        super.updateConstraints()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
