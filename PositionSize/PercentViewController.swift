//
//  PercentViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

struct PercentObject {
    var headerString: String!
    var footerString: String!
    var step: Double = 0.1
    var percentage: Double = 0.0

    init(header: String!, footer: String!) {
        headerString = header
        footerString = footer
    }
}

class PercentViewController: UIViewController {
    var headerLabel: UILabel!
    var footerLabel: UILabel!

    var textLabel: UILabel!
    var sliderView: UISlider!

    var cancelButton: UIButton!
    var saveButton: UIButton!

    var cancelBlock: ((controller: PercentViewController) -> Void)?
    var saveBlock: ((controller: PercentViewController, percent: PercentObject) -> Void)?

    var percent: PercentObject!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(percent: PercentObject) {
        super.init(nibName: nil, bundle: nil)
        self.percent = percent
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel = UILabel(frame: CGRectZero)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.textColor = Color.darkGray
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.font = UIFont.systemFontOfSize(20.0)
        headerLabel.textAlignment = .Center

        headerLabel.text = percent.headerString

        self.view.addSubview(headerLabel)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.textColor = Color.text
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.font = UIFont.systemFontOfSize(70.0)
        textLabel.textAlignment = .Center

        textLabel.text = "0.0%"

        self.view.addSubview(textLabel)

        sliderView = UISlider(frame: CGRectZero)
        sliderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        sliderView.minimumTrackTintColor = Color.highlight
        sliderView.maximumTrackTintColor = Color.highlight

        self.view.addSubview(sliderView)

//        footerLabel = UILabel(frame: CGRectZero)
//        footerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//        footerLabel.textColor = Color.text
//        footerLabel.backgroundColor = UIColor.clearColor()
//        footerLabel.font = UIFont.systemFontOfSize(12.0)
//        footerLabel.textAlignment = .Center
//        footerLabel.numberOfLines = 2;
//
//        footerLabel.text = percent.headerString
//
//        self.view.addSubview(footerLabel)

        cancelButton = UIButton.roundedButton(color: Color.gray)
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.setTitle("Cancel", forState: .Normal)

        cancelButton.addTarget(self, action: "dismissAction:", forControlEvents: .TouchUpInside)

        cancelButton.autoSetDimensionsToSize(CGSizeMake(130.0, 37.0))

        self.view.addSubview(cancelButton)

        saveButton = UIButton.roundedButton(color: Color.highlight)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveButton.setTitle("Save", forState: .Normal)

        saveButton.addTarget(self, action: "saveAction:", forControlEvents: .TouchUpInside)

        saveButton.autoSetDimensionsToSize(CGSizeMake(130.0, 37.0))
        
        self.view.addSubview(saveButton)

        // AutoLayout

        headerLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 40.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        textLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        textLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        textLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 15.0)

        sliderView.autoPinEdge(.Top, toEdge: .Bottom, ofView: textLabel, withOffset: 15.0)
        sliderView.autoPinEdgeToSuperviewEdge(.Left, withInset: 30.0)
        sliderView.autoPinEdgeToSuperviewEdge(.Right, withInset: 30.0)

        cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: sliderView, withOffset: 50.0)
        cancelButton.autoAlignAxis(.Vertical, toSameAxisOfView: self.view, withOffset: -75.0)

        saveButton.autoPinEdge(.Top, toEdge: .Top, ofView: cancelButton)
        saveButton.autoAlignAxis(.Vertical, toSameAxisOfView: self.view, withOffset: 75.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func dismissAction(sender: AnyObject!) {
        if let block = cancelBlock {
            block(controller: self)
        }
    }

    func saveAction(sender: AnyObject!) {
        if let block = saveBlock {
            block(controller: self, percent: percent)
        }
    }
}
