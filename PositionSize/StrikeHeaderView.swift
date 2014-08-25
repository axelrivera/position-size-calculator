//
//  StrikeHeaderView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/14/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class StrikeHeaderView: UIView {

    let textLabel: UILabel!
    private let leftLine: UIView!
    private let rightLine: UIView!

    override required init(frame: CGRect) {
        super.init(frame: frame)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textColor = Color.text
        textLabel.font = UIFont.systemFontOfSize(12.0)
        textLabel.textAlignment = .Center

        self.addSubview(textLabel)

        leftLine = UIView(frame: CGRectZero)
        leftLine.backgroundColor = Color.border

        leftLine.autoSetDimension(.Height, toSize: 0.5)

        self.addSubview(leftLine)

        rightLine = UIView(frame: CGRectZero)
        rightLine.backgroundColor = Color.border

        rightLine.autoSetDimension(.Height, toSize: 0.5)

        self.addSubview(rightLine)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        textLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        textLabel.autoAlignAxisToSuperviewAxis(.Vertical)

        leftLine.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        leftLine.autoPinEdge(.Right, toEdge: .Left, ofView: textLabel, withOffset: -5.0)
        leftLine.autoAlignAxis(.Horizontal, toSameAxisOfView: textLabel)

        rightLine.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)
        rightLine.autoPinEdge(.Left, toEdge: .Right, ofView: textLabel, withOffset: 5.0)
        rightLine.autoAlignAxis(.Horizontal, toSameAxisOfView: textLabel)

        super.updateConstraints()
    }

    func setText(text: String!) {
        textLabel.text = text
        textLabel.sizeToFit()
        self.setNeedsUpdateConstraints()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 16.0)
    }
    
}
