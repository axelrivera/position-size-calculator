//
//  ActionView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/15/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ActionView: UIView {

    struct Properties {
        static let height: CGFloat = 200.0
    }

    let horizontalLine: UIView!
    let verticalLine: UIView!

    let riskButton: UIButton!
    let riskLabel: UILabel!

    let sizeButton: UIButton!
    let sizeLabel: UILabel!

    let entryButton: UIButton!
    let entryLabel: UILabel!

    let stopButton: UIButton!
    let stopLabel: UILabel!

    private let riskContainerView: UIView!
    private let sizeContainerView: UIView!
    private let entryContainerView: UIView!
    private let stopContainerView: UIView!

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        horizontalLine = UIView(frame: CGRectZero)
        horizontalLine.setTranslatesAutoresizingMaskIntoConstraints(false)
        horizontalLine.backgroundColor = UIColor.lightGrayColor()

        horizontalLine.autoSetDimension(.Height, toSize: 0.5)

        self.addSubview(horizontalLine)

        verticalLine = UIView(frame: CGRectZero)
        verticalLine.setTranslatesAutoresizingMaskIntoConstraints(false)
        verticalLine.backgroundColor = UIColor.lightGrayColor()

        verticalLine.autoSetDimension(.Width, toSize: 0.5)

        self.addSubview(verticalLine)

        // Risk Percentage

        riskContainerView = UIView(frame: CGRectZero)
        riskContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskContainerView.backgroundColor = UIColor.clearColor()

        self.addSubview(riskContainerView)

        riskButton = ActionView.actionButton()

        riskContainerView.addSubview(riskButton)

        riskLabel = ActionView.actionLabel()
        riskLabel.text = "Risk Percentage"

        riskContainerView.addSubview(riskLabel)

        // Maximum Position Size

        sizeContainerView = UIView(frame: CGRectZero)
        sizeContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        sizeContainerView.backgroundColor = UIColor.clearColor()

        self.addSubview(sizeContainerView)

        sizeButton = ActionView.actionButton()

        sizeContainerView.addSubview(sizeButton)

        sizeLabel = ActionView.actionLabel()
        sizeLabel.text = "Maximum Position Size"
        
        sizeContainerView.addSubview(sizeLabel)

        // Entry Price

        entryContainerView = UIView(frame: CGRectZero)
        entryContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        entryContainerView.backgroundColor = UIColor.clearColor()

        self.addSubview(entryContainerView)

        entryButton = ActionView.actionButton()

        entryContainerView.addSubview(entryButton)

        entryLabel = ActionView.actionLabel()
        entryLabel.text = "Entry Price"
        
        entryContainerView.addSubview(entryLabel)

        // Stop Price

        stopContainerView = UIView(frame: CGRectZero)
        stopContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        stopContainerView.backgroundColor = UIColor.clearColor()

        self.addSubview(stopContainerView)

        stopButton = ActionView.actionButton()

        stopContainerView.addSubview(stopButton)

        stopLabel = ActionView.actionLabel()
        stopLabel.text = "Stop Loss Price"

        stopContainerView.addSubview(stopLabel)
    }

    override func updateConstraints() {
        horizontalLine.autoAlignAxisToSuperviewAxis(.Horizontal)
        horizontalLine.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        horizontalLine.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        verticalLine.autoAlignAxisToSuperviewAxis(.Vertical)
        verticalLine.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
        verticalLine.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.0)

        // Risk Percent

        riskContainerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5.0)
        riskContainerView.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: 5.0)
        riskContainerView.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: -5.0)
        riskContainerView.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: -5.0)

        riskLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        riskLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        riskLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        riskButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: riskLabel, withOffset: 0.0)
        riskButton.autoPinEdge(.Left, toEdge: .Left, ofView: riskLabel)
        riskButton.autoPinEdge(.Right, toEdge: .Right, ofView: riskLabel)

        // Maximum Position Size

        sizeContainerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5.0)
        sizeContainerView.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: 5.0)
        sizeContainerView.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: -5.0)
        sizeContainerView.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: -5.0)

        sizeLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        sizeLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        sizeLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        sizeButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: sizeLabel, withOffset: 0.0)
        sizeButton.autoPinEdge(.Left, toEdge: .Left, ofView: sizeLabel)
        sizeButton.autoPinEdge(.Right, toEdge: .Right, ofView: sizeLabel)

        // Entry Price

        entryContainerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5.0)
        entryContainerView.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: 5.0)
        entryContainerView.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: -5.0)
        entryContainerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: 5.0)

        entryLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        entryLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        entryLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        entryButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: entryLabel, withOffset: 0.0)
        entryButton.autoPinEdge(.Left, toEdge: .Left, ofView: entryLabel)
        entryButton.autoPinEdge(.Right, toEdge: .Right, ofView: entryLabel)

        // Stop Loss Price

        stopContainerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5.0)
        stopContainerView.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: 5.0)
        stopContainerView.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: -5.0)
        stopContainerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: 5.0)

        stopLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        stopLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        stopLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        stopButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: stopLabel, withOffset: 0.0)
        stopButton.autoPinEdge(.Left, toEdge: .Left, ofView: stopLabel)
        stopButton.autoPinEdge(.Right, toEdge: .Right, ofView: stopLabel)

        super.updateConstraints()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, Properties.height)
    }

    private class func actionLabel() -> UILabel! {
        var label: UILabel! = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(10.0)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()

        return label
    }

    private class func actionButton() -> UIButton! {
        var button: UIButton! = UIButton.buttonWithType(.System) as UIButton
        button.setTranslatesAutoresizingMaskIntoConstraints(false)

        button.titleLabel.font = UIFont.systemFontOfSize(28.0)
        button.titleLabel.textAlignment = .Center
        button.titleLabel.minimumScaleFactor = 12.0 / 20.0;
        button.titleLabel.adjustsFontSizeToFitWidth = true;

        button.setTitle("Select", forState: .Normal)

        return button
    }
}
