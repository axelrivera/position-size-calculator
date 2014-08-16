//
//  MainViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/13/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var settingsButton: UIButton!
    var accountSizeTitleLabel: UILabel!
    var accountSizeButton: UIButton!
    var segmentedControl: UISegmentedControl!
    var investorHeader: StrikeHeaderView!
    var actionView: ActionView!


    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton = UIButton.buttonWithType(.System) as UIButton!
        settingsButton.setImage(UIImage(named: "settings"), forState: .Normal)

        settingsButton.addTarget(self, action: "settingsAction:", forControlEvents: .TouchUpInside)

        self.view.addSubview(settingsButton)

        accountSizeTitleLabel = UILabel(frame: CGRectZero)
        accountSizeTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        accountSizeTitleLabel.font = UIFont.systemFontOfSize(12.0)
        accountSizeTitleLabel.textColor = UIColor.grayColor()
        accountSizeTitleLabel.backgroundColor = UIColor.clearColor()
        accountSizeTitleLabel.textAlignment = .Left

        accountSizeTitleLabel.text = "Account Size"

        self.view.addSubview(accountSizeTitleLabel)

        accountSizeButton = UIButton.buttonWithType(.System) as UIButton
        accountSizeButton.setTranslatesAutoresizingMaskIntoConstraints(false)

        accountSizeButton.titleLabel.font = UIFont.systemFontOfSize(28.0)
        accountSizeButton.titleLabel.textAlignment = .Center
        accountSizeButton.titleLabel.minimumScaleFactor = 12.0 / 28.0;
        accountSizeButton.titleLabel.adjustsFontSizeToFitWidth = true;

        accountSizeButton.setTitle("Tap to Enter Your Account Size", forState: .Normal)

        self.view.addSubview(accountSizeButton)

        let lineView = UIView(frame: CGRectZero)
        lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineView.backgroundColor = UIColor.lightGrayColor()

        lineView.autoSetDimension(.Height, toSize: 0.5)

        self.view.addSubview(lineView)

        segmentedControl = UISegmentedControl(items: [ "Aggressive", "Moderate", "Conservative" ])
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 0)
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 1)
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 2)

        self.view.addSubview(segmentedControl)

        investorHeader = StrikeHeaderView(frame: CGRectZero)
        investorHeader.setTranslatesAutoresizingMaskIntoConstraints(false)

        investorHeader.setText("SELECT YOUR INVESTMENT TYPE")

        self.view.addSubview(investorHeader)

        actionView = ActionView(frame: CGRectZero)
        actionView.setTranslatesAutoresizingMaskIntoConstraints(false)

        actionView.autoSetDimension(.Height, toSize: ActionView.Properties.height)

        self.view.addSubview(actionView)

        // AutoLayout

        settingsButton.autoPinToTopLayoutGuideOfViewController(self, withInset: 15.0)
        settingsButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        accountSizeTitleLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 15.0)
        accountSizeTitleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)

        accountSizeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: accountSizeTitleLabel, withOffset: 10.0)
        accountSizeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        accountSizeButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)

        lineView.autoPinEdge(.Top, toEdge: .Bottom, ofView: accountSizeButton, withOffset: 15.0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        segmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView, withOffset: 15.0)
        segmentedControl.autoAlignAxisToSuperviewAxis(.Vertical)

        investorHeader.autoPinEdge(.Top, toEdge: .Bottom, ofView: segmentedControl, withOffset: 15.0)
        investorHeader.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        investorHeader.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        actionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: investorHeader, withOffset: 15.0)
        actionView.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        actionView.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func settingsAction(sender: AnyObject!) {
        let settingsController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsController)

        self.presentViewController(navController, animated: true, completion: nil)
    }

    func accountSizeAction(sender: AnyObject!) {

    }
}
