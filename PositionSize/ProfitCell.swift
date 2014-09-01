//
//  ProfitCell.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/31/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ProfitCell: UITableViewCell {

    class var defaultHeight: CGFloat {
        get {
            return ProfitView.defaultHeight
        }
    }

    var profitView: ProfitView!

    var decorationLabel: UILabel {
        get {
            return profitView.decorationLabel
        }
    }

    var riskLabel: UILabel {
        get {
            return profitView.riskLabel
        }
    }

    var shareTitleLabel: UILabel {
        get {
            return profitView.shareTitleLabel
        }
    }

    var shareLabel: UILabel {
        get {
            return profitView.shareLabel
        }
    }

    var totalTitleLabel: UILabel {
        get {
            return profitView.totalTitleLabel
        }
    }

    var totalLabel: UILabel {
        get {
            return profitView.totalLabel
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

        profitView = ProfitView(frame: CGRectZero)
        profitView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.contentView.addSubview(profitView)
    }

    override func updateConstraints() {
        profitView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        super.updateConstraints()
    }

    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
}
