//
//  ProfitHeaderView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/31/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ProfitHeaderView: UIView {

    struct Config {
        static let defaultHeight: CGFloat = 100.0
        static let sectionWidth: CGFloat = 130.0
    }

    var entryView: TextDetailView!
    var stopView: TextDetailView!
    var sharesView: TextDetailView!
    var riskView: TextDetailView!

    class var defaultHeight: CGFloat {
        return Config.defaultHeight
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        entryView = TextDetailView(frame: CGRectZero)
        entryView.setTranslatesAutoresizingMaskIntoConstraints(false)
        entryView.setDetailText("Entry Price")

        entryView.autoSetDimension(.Width, toSize: Config.sectionWidth)

        self.addSubview(entryView)

        stopView = TextDetailView(frame: CGRectZero)
        stopView.setTranslatesAutoresizingMaskIntoConstraints(false)
        stopView.setDetailText("Stop Loss Price")

        stopView.autoSetDimension(.Width, toSize: Config.sectionWidth)

        self.addSubview(stopView)

        sharesView = TextDetailView(frame: CGRectZero)
        sharesView.setTranslatesAutoresizingMaskIntoConstraints(false)
        sharesView.setDetailText("Shares")

        sharesView.autoSetDimension(.Width, toSize: Config.sectionWidth)

        self.addSubview(sharesView)

        riskView = TextDetailView(frame: CGRectZero)
        riskView.setTranslatesAutoresizingMaskIntoConstraints(false)
        riskView.setDetailText("Total Risk")

        riskView.autoSetDimension(.Width, toSize: Config.sectionWidth)

        self.addSubview(riskView)
    }

    override func updateConstraints() {
        entryView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        entryView.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)

        stopView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        stopView.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)

        sharesView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        sharesView.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)

        riskView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        riskView.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)

        super.updateConstraints()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, Config.defaultHeight)
    }
}
