//
//  PercentViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/23/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

struct PercentConfig {
    var header: String!
    var footer: String!
    var step: Double = 1.0
    var minValue: Double = 0.0
    var maxValue: Double = 100.0
    var percent: Double = 0.0
    var showDecimalValues: Bool = false

    init(header: String!, footer: String!) {
        self.header = header
        self.footer = footer
    }
}

class PercentViewController: UIViewController {

    var headerLabel: UILabel!
    var footerLabel: UILabel!

    var textLabel: UILabel!
    var stepperView: UIStepper!

    var resetButton: UIButton!
    var cancelButton: UIButton!
    var saveButton: UIButton!

    let config: PercentConfig!
    var percent: Double = 0.0

    var cancelBlock: ((controller: PercentViewController) -> Void)?
    var saveBlock: ((controller: PercentViewController, percent: Double) -> Void)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: PercentConfig) {
        super.init(nibName: nil, bundle: nil)
        self.config = config
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        percent = config.percent

        headerLabel = UILabel(frame: CGRectZero)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.textColor = Color.darkGray
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.font = UIFont.systemFontOfSize(20.0)
        headerLabel.textAlignment = .Center

        headerLabel.text = config.header

        self.view.addSubview(headerLabel)

        textLabel = UILabel(frame: CGRectZero)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        textLabel.textColor = Color.text
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.font = UIFont.systemFontOfSize(50.0)
        textLabel.minimumScaleFactor = 20.0 / 50.0
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .Center

        self.view.addSubview(textLabel)

        stepperView = UIStepper(frame: CGRectZero)
        stepperView.setTranslatesAutoresizingMaskIntoConstraints(false)
        stepperView.minimumValue = config.minValue
        stepperView.maximumValue = config.maxValue
        stepperView.stepValue = config.step

        stepperView.addTarget(self, action: "stepperChanged:", forControlEvents: .ValueChanged)

        self.view.addSubview(stepperView)

        resetButton = UIButton.buttonWithType(.System) as UIButton
        resetButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        resetButton.setTitle("Reset to Initial Value", forState: .Normal)

        resetButton.addTarget(self, action: "resetAction:", forControlEvents: .TouchUpInside)

        self.view.addSubview(resetButton)

        cancelButton = UIButton.roundedButton(color: Color.gray)
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.setTitle("Cancel", forState: .Normal)

        cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)

        cancelButton.autoSetDimension(.Height, toSize: 37.0)

        self.view.addSubview(cancelButton)

        saveButton = UIButton.roundedButton(color: Color.highlight)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveButton.setTitle("Save", forState: .Normal)

        saveButton.addTarget(self, action: "saveAction:", forControlEvents: .TouchUpInside)

        saveButton.autoSetDimension(.Height, toSize: 37.0)
        
        self.view.addSubview(saveButton)

        footerLabel = UILabel(frame: CGRectZero)
        footerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        footerLabel.textColor = Color.text
        footerLabel.backgroundColor = UIColor.clearColor()
        footerLabel.font = UIFont.systemFontOfSize(12.0)
        footerLabel.textAlignment = .Center
        footerLabel.numberOfLines = 0;

        footerLabel.text = config.footer

        self.view.addSubview(footerLabel)

        // AutoLayout

        headerLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 20.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        textLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        textLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 15.0)

        stepperView.autoAlignAxis(.Horizontal, toSameAxisOfView: textLabel)
        stepperView.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        textLabel.autoPinEdge(.Right, toEdge: .Left, ofView: stepperView, withOffset: -15.0)

        resetButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: textLabel, withOffset: 15.0)
        resetButton.autoAlignAxisToSuperviewAxis(.Vertical)

        cancelButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: resetButton, withOffset: 25.0)
        cancelButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        saveButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        saveButton.autoPinEdge(.Top, toEdge: .Top, ofView: cancelButton)
        saveButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        footerLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cancelButton, withOffset: 20.0)
        footerLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        footerLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        // Default Values

        resetAction(nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logPageView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        var animation = CATransition()
        animation.duration = 0.1
        animation.type = kCATransitionFade
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.removedOnCompletion = false

        textLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func resetAction(sender: AnyObject!) {
        Flurry.logEvent(AnalyticsKeys.resetToInitialValue)

        stepperView.value = config.percent
        stepperChanged(stepperView)
    }

    func cancelAction(sender: AnyObject!) {
        if let block = cancelBlock {
            block(controller: self)
        }
    }

    func saveAction(sender: AnyObject!) {
        if let block = saveBlock {
            block(controller: self, percent: percent)
        }
    }

    func stepperChanged(stepper: UIStepper) {
        percent = stepper.value

        let decimalNumber = NSDecimalNumber(double: percent / 100.0)
        self.textLabel.text = config.showDecimalValues ? decimalNumber.doublePercentString() : decimalNumber.percentString()
    }
}
