//
//  ButtonCell.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/4/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    class var defaultHeight: CGFloat {
        get {
            return 44.0
        }
    }

    var titleLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(reuseIdentifier: String!) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .Default
        self.accessoryType = .None
        self.opaque = true

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = Color.highlight
        titleLabel.backgroundColor = UIColor.clearColor()

        self.contentView.addSubview(titleLabel)

        titleLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
    }

    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        super.updateConstraints()
    }

}
