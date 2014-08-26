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

    var position: Position!

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        position = Position()
        position.updateValuesForTraderProfile(AppConfig.defaultTraderProfile())

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

        accountSizeButton.titleLabel.font = UIFont.systemFontOfSize(36.0)
        accountSizeButton.titleLabel.textAlignment = .Center
        accountSizeButton.titleLabel.minimumScaleFactor = 12.0 / 36.0;
        accountSizeButton.titleLabel.adjustsFontSizeToFitWidth = true;

        accountSizeButton.addTarget(self, action: "accountSizeAction:", forControlEvents: .TouchUpInside)

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
        segmentedControl.momentary = true

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

        summaryView.setStatus(.NotApproved)

        summaryView.setShares("100")
        summaryView.setTradeCost("$1,234.00")
        summaryView.setAllowedShares("90")
        summaryView.setAllowedTradeCost("$1,000.00")

        // Default Values

        updatePositionValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Public Methods

    func updatePositionValues() {
        accountSizeButton.setTitle(position.accountSizeString(), forState: .Normal)

        actionView.setRiskHeaderText(position.riskPercentageTotalString())
        actionView.setRiskText(position.riskPercentageString())

        actionView.setPositionSizeHeaderText(position.maxPositionSizeTotalString())
        actionView.setPositionSizeText(position.maxPositionSizeString())

        actionView.setEntryHeaderText(position.tradeTypeString())
        actionView.setEntryPriceText(position.entryPriceString())

        actionView.setStopHeaderText(position.riskTotalString())
        actionView.setStopPriceText(position.stopPriceString())

        if position.isReady {
            if position.tradeType == TradeType.Long {
                summaryView.setStatus(.Approved)
            } else {
                summaryView.setStatus(.NotApproved)
            }
        } else {
            summaryView.setStatus(.None)
        }
    }

    // MARK: - Selector Methods

    func settingsAction(sender: AnyObject!) {
        let settingsController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsController)

        self.presentViewController(navController, animated: true, completion: nil)
    }

    func accountSizeAction(sender: AnyObject!) {
        var config = PriceConfig(header: "Account Size")
        config.priceType = .Account
        config.defaultPrice = position.accountSize

        let priceController = PriceViewController(config: config)
        priceController.modalTransitionStyle = .CrossDissolve

        priceController.saveBlock = { [weak self] (controller: PriceViewController, price: NSDecimalNumber, tradeType: TradeType) in
            if let weakSelf = self {
                weakSelf.position.accountSize = price
                weakSelf.updatePositionValues()

                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        priceController.cancelBlock = { [weak self] (controller: PriceViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(priceController, animated: true, completion: nil)
    }

    func segmentedControlChanged(segmentedControl: UISegmentedControl!) {
        position.updateValuesForTraderProfile(AppConfig.traderProfileForIndex(segmentedControl.selectedSegmentIndex))
        updatePositionValues()
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
        var config = PercentConfig(header: "Risk Percentage", footer: nil)
        config.minValue = 0.0
        config.maxValue = 10.0
        config.step = 0.25
        config.percent = position.riskPercentage.floatValue * 100.0

        let percentController = PercentViewController(config: config)
        percentController.modalTransitionStyle = .CrossDissolve

        percentController.saveBlock = { [weak self] (controller: PercentViewController, percent: Float) in
            if let weakSelf = self {
                weakSelf.position.riskPercentage = NSDecimalNumber(float: percent / 100.0)
                weakSelf.updatePositionValues()

                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        percentController.cancelBlock = { [weak self] (controller: PercentViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(percentController, animated: true, completion: nil)
    }

    func positionSize(sender: AnyObject!) {
        var config = PercentConfig(header: "Maximum Position Size", footer: nil)
        config.minValue = 0.0
        config.maxValue = 100.0
        config.step = 1.0
        config.percent = position.maxPositionSize.floatValue * 100.0

        let percentController = PercentViewController(config: config)
        percentController.modalTransitionStyle = .CrossDissolve

        percentController.saveBlock = { [weak self] (controller: PercentViewController, percent: Float) in
            if let weakSelf = self {
                weakSelf.position.maxPositionSize = NSDecimalNumber(float: percent / 100.0)
                weakSelf.updatePositionValues()

                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        percentController.cancelBlock = { [weak self] (controller: PercentViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(percentController, animated: true, completion: nil)
    }

    func entryAction(sender: AnyObject!) {
        var config = PriceConfig(header: "Entry Price")
        config.priceType = .Entry
        config.tradeType = position.tradeType
        config.defaultPrice = position.entryPrice

        let priceController = PriceViewController(config: config)
        priceController.modalTransitionStyle = .CrossDissolve

        priceController.saveBlock = { [weak self] (controller: PriceViewController, price: NSDecimalNumber, tradeType: TradeType) in
            if let weakSelf = self {
                weakSelf.position.entryPrice = price
                weakSelf.position.tradeType = tradeType
                weakSelf.updatePositionValues()

                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        priceController.cancelBlock = { [weak self] (controller: PriceViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(priceController, animated: true, completion: nil)
    }

    func stopAction(sender: AnyObject!) {
        var config = PriceConfig(header: "Stop Loss Price")
        config.priceType = .Stop
        config.defaultPrice = position.stopPrice

        let priceController = PriceViewController(config: config)
        priceController.modalTransitionStyle = .CrossDissolve

        priceController.saveBlock = { [weak self] (controller: PriceViewController, price: NSDecimalNumber, tradeType: TradeType) in
            if let weakSelf = self {
                weakSelf.position.stopPrice = price
                weakSelf.updatePositionValues()

                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        priceController.cancelBlock = { [weak self] (controller: PriceViewController) in
            if let weakSelf = self {
                weakSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        self.presentViewController(priceController, animated: true, completion: nil)
    }

}
