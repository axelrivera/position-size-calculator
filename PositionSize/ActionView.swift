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
        static let padding: CGFloat = 0.0
    }

    var delegate: ActionViewDelegate?

    let horizontalLine: UIView!
    let verticalLine: UIView!

    let riskTile: ActionTileView!
    let positionSizeTile: ActionTileView!
    let entryTile: ActionTileView!
    let stopTile: ActionTileView!

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

        riskTile = ActionTileView(frame: CGRectZero)
        riskTile.setTranslatesAutoresizingMaskIntoConstraints(false)

        riskTile.tag = ActionViewButtonType.Risk.toRaw()
        riskTile.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

        riskTile.footerLabel.text = "Risk Percentage"

        self.addSubview(riskTile)

        // Maximum Position Size

        positionSizeTile = ActionTileView(frame: CGRectZero)
        positionSizeTile.setTranslatesAutoresizingMaskIntoConstraints(false)

        positionSizeTile.tag = ActionViewButtonType.PositionSize.toRaw()
        positionSizeTile.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

        positionSizeTile.headerLabel.font = UIFont.boldSystemFontOfSize(11.0)
        positionSizeTile.footerLabel.text = "Maximum Position Size"

        self.addSubview(positionSizeTile)

        // Entry Price

        entryTile = ActionTileView(frame: CGRectZero)
        entryTile.setTranslatesAutoresizingMaskIntoConstraints(false)

        entryTile.tag = ActionViewButtonType.Entry.toRaw()
        entryTile.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

        entryTile.headerLabel.font = UIFont.boldSystemFontOfSize(11.0)
        entryTile.footerLabel.text = "Entry Price"

        self.addSubview(entryTile)

        // Stop Price

        stopTile = ActionTileView(frame: CGRectZero)
        stopTile.setTranslatesAutoresizingMaskIntoConstraints(false)

        stopTile.tag = ActionViewButtonType.Stop.toRaw()
        stopTile.addTarget(self, action: "selectAction:", forControlEvents: .TouchUpInside)

        stopTile.footerLabel.text = "Stop Loss Price"

        self.addSubview(stopTile)
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

        riskTile.autoPinEdgeToSuperviewEdge(.Top, withInset: Config.padding)
        riskTile.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: Config.padding)
        riskTile.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: -Config.padding)
        riskTile.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: -Config.padding)

        // Maximum Position Size

        positionSizeTile.autoPinEdgeToSuperviewEdge(.Top, withInset: Config.padding)
        positionSizeTile.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: Config.padding)
        positionSizeTile.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: Config.padding)
        positionSizeTile.autoPinEdge(.Bottom, toEdge: .Top, ofView: horizontalLine, withOffset: -Config.padding)

        // Entry Price

        entryTile.autoPinEdgeToSuperviewEdge(.Bottom, withInset: Config.padding)
        entryTile.autoPinEdge(.Left, toEdge: .Left, ofView: horizontalLine, withOffset: Config.padding)
        entryTile.autoPinEdge(.Right, toEdge: .Left, ofView: verticalLine, withOffset: -Config.padding)
        entryTile.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: Config.padding)

        // Stop Loss Price

        stopTile.autoPinEdgeToSuperviewEdge(.Bottom, withInset: Config.padding)
        stopTile.autoPinEdge(.Left, toEdge: .Right, ofView: verticalLine, withOffset: Config.padding)
        stopTile.autoPinEdge(.Right, toEdge: .Right, ofView: horizontalLine, withOffset: Config.padding)
        stopTile.autoPinEdge(.Top, toEdge: .Bottom, ofView: horizontalLine, withOffset: Config.padding)

        super.updateConstraints()
    }

    // MARK: Public Methods

    func setRiskHeaderText(text: NSString!) {
        riskTile.headerLabel.text = text
    }

    func setRiskHeaderAttributedText(text: NSAttributedString!) {
        riskTile.headerLabel.attributedText = text
    }

    func setRiskText(text: NSString!) {
        var string: String = "Select"

        if let tmp = text {
            string = tmp
        }

        riskTile.textLabel.text = string
    }

    func setPositionSizeHeaderText(text: NSString!) {
        positionSizeTile.headerLabel.text = text
    }

    func setPositionSizeText(text: NSString!) {
        var string: String = "Select"

        if let tmp = text {
            string = tmp
        }

        positionSizeTile.textLabel.text = string
    }

    func setEntryHeaderText(text: NSString!) {
        entryTile.headerLabel.text = text
    }

    func setEntryPriceText(text: NSString!) {
        var string: String = "Select"

        if let tmp = text {
            string = tmp
        }

        entryTile.textLabel.text = string
    }

    func setStopHeaderText(text: NSString!) {
        stopTile.headerLabel.text = text
    }

    func setStopHeaderAttributedText(text: NSAttributedString!) {
        stopTile.headerLabel.attributedText = text
    }

    func setStopPriceText(text: NSString!) {
        var string: String = "Select"

        if let tmp = text {
            string = tmp
        }

        stopTile.textLabel.text = string
    }

    // MARK: Selector Methods

    func selectAction(sender: AnyObject!) {
        let buttonType: ActionViewButtonType! = ActionViewButtonType.fromRaw(sender.tag)!
        delegate?.actionView(self, didSelectButtonType: buttonType)
    }
    
}
