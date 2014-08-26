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
    var step: Float = 1.0
    var minValue: Float = 0.0
    var maxValue: Float = 100.0
    var percent: Float = 0.0

    init(header: String!, footer: String!) {
        self.header = header
        self.footer = footer
    }
}

class PercentViewController: UIViewController {

    var headerLabel: UILabel!
    var footerLabel: UILabel!

    var textLabel: UILabel!
    var sliderView: UISlider!

    var cancelButton: UIButton!
    var saveButton: UIButton!

    let config: PercentConfig!
    var percent: Float = 0.0

    var cancelBlock: ((controller: PercentViewController) -> Void)?
    var saveBlock: ((controller: PercentViewController, percent: Float) -> Void)?

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
        textLabel.font = UIFont.systemFontOfSize(70.0)
        textLabel.textAlignment = .Center

        self.view.addSubview(textLabel)

        sliderView = UISlider(frame: CGRectZero)
        sliderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        sliderView.minimumTrackTintColor = Color.highlight
        sliderView.maximumTrackTintColor = Color.highlight

        sliderView.minimumValue = config.minValue
        sliderView.maximumValue = config.maxValue

        sliderView.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)

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

        cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)

        cancelButton.autoSetDimension(.Height, toSize: 37.0)

        self.view.addSubview(cancelButton)

        saveButton = UIButton.roundedButton(color: Color.highlight)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveButton.setTitle("Save", forState: .Normal)

        saveButton.addTarget(self, action: "saveAction:", forControlEvents: .TouchUpInside)

        saveButton.autoSetDimension(.Height, toSize: 37.0)
        
        self.view.addSubview(saveButton)

        // AutoLayout

        headerLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 20.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        textLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        textLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        textLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 15.0)

        sliderView.autoPinEdge(.Top, toEdge: .Bottom, ofView: textLabel, withOffset: 15.0)
        sliderView.autoPinEdgeToSuperviewEdge(.Left, withInset: 30.0)
        sliderView.autoPinEdgeToSuperviewEdge(.Right, withInset: 30.0)

        cancelButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: sliderView, withOffset: 50.0)
        cancelButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        saveButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        saveButton.autoPinEdge(.Top, toEdge: .Top, ofView: cancelButton)
        saveButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        // Default Values

        sliderView.value = percent
        sliderChanged(sliderView)
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

    func sliderChanged(slider: UISlider) {
        let tmpStep = roundf(slider.value / config.step)
        percent = tmpStep * config.step

        slider.value = percent
        self.textLabel.text = NSDecimalNumber(float: self.percent / 100.0).percentString()
    }
}
