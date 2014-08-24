//
//  ActionView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/15/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

enum ActionViewButtonType: Int {
    case Risk = 1, PositionSize, Entry, Stop
}

protocol ActionViewDelegate {
    func actionView(actionView: ActionView, didSelectButtonType buttonType: ActionViewButtonType)
}

class ActionView: UIView {
    struct Config {
        static let buttonHeight: CGFloat = 32.0
        static let verticalLinePadding: CGFloat = 20.0
        static let verticalTextPadding: CGFloat = 10.0
    }

    var delegate: ActionViewDelegate?

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

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        horizontalLine = UIView(frame: CGRectZero)
        horizontalLine.setTranslatesAutoresizingMaskIntoConstraints(false)
        horizontalLine.backgroundColor = Color.border

        horizontalLine.autoSetDimension(.Height, toSize: 0.5)

        self.addSubview(horizontalLine)

        verticalLine = UIView(frame: CGRectZero)
        verticalLine.setTranslatesAutoresizingMaskIntoConstraints(false)
        verticalLine.backgroundColor = Color.border

        verticalLine.autoSetDimension(.Width, toSize: 0.5)

        self.addSubview(verticalLine)

        // Risk Percentage

        riskContainerView = UIView(frame: CGRectZero)
        riskContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskContainerView.backgroundColor = UIColor.clearColor()

        self.addSubview(riskContainerView)

        riskButton = ActionView.actionButton()
        riskButton.tag = ActionViewButtonType.Risk.toRaw()

        riskButton.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

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
        sizeButton.tag = ActionViewButtonType.PositionSize.toRaw()

        sizeButton.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

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
        entryButton.tag = ActionViewButtonType.Entry.toRaw()

        entryButton.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

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
        stopButton.tag = ActionViewButtonType.Stop.toRaw()

        stopButton.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

        stopContainerView.addSubview(stopButton)

        stopLabel = ActionView.actionLabel()
        stopLabel.text = "Stop Loss Price"

        stopContainerView.addSubview(stopLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        horizontalLine.autoAlignAxisToSuperviewAxis(.Horizontal)
        horizontalLine.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        horizontalLine.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        verticalLine.autoAlignAxisToSuperviewAxis(.Vertical)
        verticalLine.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
        verticalLine.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.0)

        // Risk Percent

        riskContainerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
        riskContainerView.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: 0.0)
        riskContainerView.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: 0.0)
        riskContainerView.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: 0.0)

        riskLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: Config.verticalLinePadding)
        riskLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        riskLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        riskButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: riskLabel, withOffset: -Config.verticalTextPadding)
        riskButton.autoPinEdge(.Left, toEdge: .Left, ofView: riskLabel)
        riskButton.autoPinEdge(.Right, toEdge: .Right, ofView: riskLabel)

        riskButton.autoSetDimension(.Height, toSize: Config.buttonHeight)

        // Maximum Position Size

        sizeContainerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
        sizeContainerView.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: 0.0)
        sizeContainerView.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: 0.0)
        sizeContainerView.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: 0.0)

        sizeLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: Config.verticalLinePadding)
        sizeLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        sizeLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        sizeButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: sizeLabel, withOffset: -Config.verticalTextPadding)
        sizeButton.autoPinEdge(.Left, toEdge: .Left, ofView: sizeLabel)
        sizeButton.autoPinEdge(.Right, toEdge: .Right, ofView: sizeLabel)

        sizeButton.autoSetDimension(.Height, toSize: Config.buttonHeight)

        // Entry Price

        entryContainerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.0)
        entryContainerView.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: 0.0)
        entryContainerView.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: 0.0)
        entryContainerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: 0.0)

        entryButton.autoPinEdgeToSuperviewEdge(.Top, withInset: Config.verticalLinePadding)
        entryButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        entryButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        entryButton.autoSetDimension(.Height, toSize: Config.buttonHeight)

        entryLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: entryButton, withOffset: Config.verticalTextPadding)
        entryLabel.autoPinEdge(.Left, toEdge: .Left, ofView: entryButton)
        entryLabel.autoPinEdge(.Right, toEdge: .Right, ofView: entryButton)

        // Stop Loss Price

        stopContainerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.0)
        stopContainerView.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: 0.0)
        stopContainerView.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: 0.0)
        stopContainerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: 0.0)

        stopButton.autoPinEdgeToSuperviewEdge(.Top, withInset: Config.verticalLinePadding)
        stopButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        stopButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        stopButton.autoSetDimension(.Height, toSize: Config.buttonHeight)

        stopLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: stopButton, withOffset: Config.verticalTextPadding)
        stopLabel.autoPinEdge(.Left, toEdge: .Left, ofView: stopButton)
        stopLabel.autoPinEdge(.Right, toEdge: .Right, ofView: stopButton)

        super.updateConstraints()
    }

    // MARK: Public Methods

    func setRiskText(text: NSString!) {
        var title: String = "Select"

        if let string = text {
            title = string
        }

        riskButton.setTitle(title, forState: .Normal)
    }

    func setMaximumSizeText(text: NSString!) {
        var title: String = "Select"

        if let string = text {
            title = string
        }

        sizeButton.setTitle(title, forState: .Normal)
    }

    func setEntryPriceText(text: NSString!) {
        var title: String = "Select"

        if let string = text {
            title = string
        }

        entryButton.setTitle(title, forState: .Normal)
    }

    func setStopPriceText(text: NSString!) {
        var title: String = "Select"

        if let string = text {
            title = string
        }

        stopButton.setTitle(title, forState: .Normal)
    }

    // MARK: Selector Methods

    func selectAction(sender: AnyObject!) {
        let buttonType: ActionViewButtonType! = ActionViewButtonType.fromRaw(sender.tag)!
        delegate?.actionView(self, didSelectButtonType: buttonType)
    }

    // MARK: - Private Methods

    private class func actionLabel() -> UILabel! {
        var label: UILabel! = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(11.0)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Color.text

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
