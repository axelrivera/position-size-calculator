//
//  MainViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/13/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ActionViewDelegate {

    var settingsButton: UIButton!
    var accountSizeTitleLabel: UILabel!
    var accountSizeButton: UIButton!
    var segmentedControl: UISegmentedControl!
    var investorHeader: StrikeHeaderView!
    var actionView: ActionView!
    var summaryView: SummaryView!

    var currentTradingStyleIndex: Int!

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentTradingStyleIndex = AppConfig.indexForCurrentTraderProfile()

        settingsButton = UIButton.buttonWithType(.System) as UIButton!
        settingsButton.setImage(UIImage(named: "settings"), forState: .Normal)

        settingsButton.addTarget(self, action: "settingsAction:", forControlEvents: .TouchUpInside)

        self.view.addSubview(settingsButton)

        accountSizeTitleLabel = UILabel(frame: CGRectZero)
        accountSizeTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        accountSizeTitleLabel.font = UIFont.systemFontOfSize(12.0)
        accountSizeTitleLabel.textColor = Color.text
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
        lineView.backgroundColor = Color.border

        lineView.autoSetDimension(.Height, toSize: 0.5)

        self.view.addSubview(lineView)

        segmentedControl = UISegmentedControl(items: [ "Aggressive", "Moderate", "Conservative" ])
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 0)
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 1)
        segmentedControl.setWidth(95.0, forSegmentAtIndex: 2)

        segmentedControl.addTarget(self, action: "segmentedControlChanged:", forControlEvents: .ValueChanged)

        self.view.addSubview(segmentedControl)

        investorHeader = StrikeHeaderView(frame: CGRectZero)
        investorHeader.setTranslatesAutoresizingMaskIntoConstraints(false)

        investorHeader.setText("SELECT YOUR TRADING STYLE")

        self.view.addSubview(investorHeader)

        actionView = ActionView(frame: CGRectZero)
        actionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        actionView.delegate = self

        self.view.addSubview(actionView)

        summaryView = SummaryView(frame: CGRectZero)
        summaryView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.view.addSubview(summaryView)

        let actionHeight = ceil(self.view.bounds.height * 0.34)

        self.summaryView .autoSetDimension(ALDimension.Height, toSize: 120.0)

        // AutoLayout

        settingsButton.autoPinToTopLayoutGuideOfViewController(self, withInset: 15.0)
        settingsButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        accountSizeTitleLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        accountSizeTitleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        accountSizeButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: accountSizeTitleLabel, withOffset: 8.0)
        accountSizeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        accountSizeButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)

        lineView.autoPinEdge(.Top, toEdge: .Bottom, ofView: accountSizeButton, withOffset: 5.0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        segmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView, withOffset: 12.0)
        segmentedControl.autoAlignAxisToSuperviewAxis(.Vertical)

        investorHeader.autoPinEdge(.Top, toEdge: .Bottom, ofView: segmentedControl, withOffset: 12.0)
        investorHeader.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        investorHeader.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        actionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: investorHeader, withOffset: 10.0)
        actionView.autoPinEdge(.Bottom, toEdge: .Top, ofView: summaryView, withOffset: -10.0)
        actionView.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        actionView.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        summaryView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)

        summaryView.setStatus(.None)

        // Setup Default Values

        segmentedControl.selectedSegmentIndex = currentTradingStyleIndex
        segmentedControlChanged(segmentedControl)
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

    func segmentedControlChanged(segmentedControl: UISegmentedControl!) {
        currentTradingStyleIndex = segmentedControl.selectedSegmentIndex

        var riskStr: String
        var sizeStr: String

        if currentTradingStyleIndex == 0 {
            riskStr = "2%"
            sizeStr = "20%"
        } else if currentTradingStyleIndex == 1 {
            riskStr = "1.5%"
            sizeStr = "15%"
        } else {
            riskStr = "1%"
            sizeStr = "10%"
        }

        actionView.setRiskText(riskStr)
        actionView.setPositionSizeText(sizeStr)

        actionView.setRiskHeaderText("$100.00")
        actionView.setPositionSizeHeaderText("$20,000.00")
        actionView.setEntryHeaderText("Long")
    }

    // MARK: - ActionViewDelegate Methods

    func actionView(actionView: ActionView, didSelectButtonType buttonType: ActionViewButtonType) {
        switch buttonType {
        case .Risk:
            self.riskAction(nil)
        case .PositionSize:
            self.positionSize(nil)
        case .Entry:
            self.entryAction(nil)
        case .Stop:
            self.stopAction(nil)
        default:
            println("invalid action")
        }
    }

    func riskAction(sender: AnyObject!) {
        let percent = PercentObject(header: "Risk Percentage", footer: nil)

        let percentController = PercentViewController(percent: percent)
        percentController.modalTransitionStyle = .CrossDissolve

        percentController.cancelBlock = { [weak self] (controller: PercentViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(percentController, animated: true, completion: nil)
    }

    func positionSize(sender: AnyObject!) {

    }

    func entryAction(sender: AnyObject!) {

    }

    func stopAction(sender: AnyObject!) {

    }

}
