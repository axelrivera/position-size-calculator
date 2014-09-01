//
//  TextDetailView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/31/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class TextDetailView: UIView {

    struct Config {
        static let textHeight: CGFloat = 20.0
        static let detailHeight: CGFloat = 16.0

        static var defaultHeight: CGFloat {
            return textHeight + detailHeight
        }
    }

    var textLabel: UILabel!
    var detailTextLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.font = UIFont.systemFontOfSize(16.0)
        textLabel.textColor = Color.header
        textLabel.textAlignment = .Center

        textLabel.autoSetDimension(.Height, toSize: Config.textHeight)

        self.addSubview(textLabel)

        detailTextLabel = UILabel(frame: CGRectZero)
        detailTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        detailTextLabel.backgroundColor = UIColor.clearColor()
        detailTextLabel.font = UIFont.systemFontOfSize(12.0)
        detailTextLabel.textColor = Color.text
        detailTextLabel.textAlignment = .Center

        detailTextLabel.autoSetDimension(.Height, toSize: Config.detailHeight)

        self.addSubview(detailTextLabel)
    }

    override func updateConstraints() {
        textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        detailTextLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        super.updateConstraints()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, Config.defaultHeight)
    }

    func setText(text: String!) {
        textLabel.text = text
        self.setNeedsUpdateConstraints()
    }

    func setDetailText(detailText: String!) {
        detailTextLabel.text = detailText
        self.setNeedsUpdateConstraints()
    }
    
}
