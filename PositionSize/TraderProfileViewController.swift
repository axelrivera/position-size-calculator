//
//  TradingStyleViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/2/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

struct TraderProfileProperties {
    var title: String!
    var profile: TraderProfile = .Conservative

    var initialRisk: Double = 1
    var initialSize: Double = 10

    var defaultRisk: Double = 1
    var defaultSize: Double = 10

    init(title: NSString!, profile: TraderProfile) {
        self.title = title
        self.profile = profile
    }
}

class TraderProfileViewController: UITableViewController {

    struct Config {
        static let CellIdentifier = "Cell"
        static let SwitchIdentifier = "SwitchCell"
        static let ResetIdentifier = "ResetCell"
        static let riskTag = 100
        static let sizeTag = 200
    }

    weak var riskStepper: UIStepper?
    weak var riskLabel: UILabel?

    weak var sizeStepper: UIStepper?
    weak var sizeLabel: UILabel?

    var defaultSwitch: UISwitch!

    var properties: TraderProfileProperties!

    var risk: Double = 0
    var size: Double = 0

    var saveBlock: ((controller: TraderProfileViewController, profile: TraderProfile, risk: Double, size: Double) -> Void)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(properties: TraderProfileProperties) {
        super.init(nibName: nil, bundle: nil)
        self.properties = properties

        self.title = properties.title

        risk = properties.initialRisk
        size = properties.initialSize
    }

    override func loadView() {
        self.tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = Color.ultraLightPurple
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Save,
            target: self,
            action: "saveAction:")

        defaultSwitch = UISwitch(frame: CGRectZero)
        defaultSwitch.onTintColor = Color.highlight
        defaultSwitch.tintColor = Color.highlight

        defaultSwitch.on = AppConfig.defaultTraderProfile == properties.profile
        defaultSwitch.enabled = !(AppConfig.defaultTraderProfile == properties.profile)

        defaultSwitch.addTarget(self, action: "switchValueChanged:", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func saveAction(sender: AnyObject!) {
        if let block = saveBlock {
            block(controller: self, profile: properties.profile, risk: risk, size: size)
        }
    }

    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == Config.riskTag {
            risk = stepper.value

            if let label = riskLabel {
                label.text = NSDecimalNumber(double: risk / 100).percentString()
            }
        } else {
            size = stepper.value

            if let label = sizeLabel {
                label.text = NSDecimalNumber(double: size / 100).percentString()
            }
        }
    }

    func switchValueChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            AppConfig.defaultTraderProfile = properties.profile

            defaultSwitch.on = AppConfig.defaultTraderProfile == properties.profile
            defaultSwitch.enabled = !(AppConfig.defaultTraderProfile == properties.profile)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.SwitchIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style:.Default, reuseIdentifier: Config.SwitchIdentifier)
                cell.textLabel?.font = UIFont.systemFontOfSize(16.0)
                cell.accessoryView = defaultSwitch
            }

            cell.textLabel?.text = "Set as Default"
            cell.selectionStyle = .None

            cell.setNeedsUpdateConstraints()

            return cell
        }

        if indexPath.section == 3 {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.ResetIdentifier) as ButtonCell!
            if cell == nil {
                cell = ButtonCell(reuseIdentifier: Config.ResetIdentifier)
            }

            cell.titleLabel.text = "Use Recommended Values"
            cell.setNeedsUpdateConstraints()

            return cell
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(Config.CellIdentifier) as StepperCell!
        if cell == nil {
            cell = StepperCell(reuseIdentifier: Config.CellIdentifier)
        }

        if indexPath.section == 0 {
            cell.titleLabel.text = "Risk Percent"
            cell.stepper.minimumValue = 0.0
            cell.stepper.maximumValue = 10.0
            cell.stepper.stepValue = 0.25
            cell.stepper.value = risk
            cell.stepper.tag = Config.riskTag

            cell.supportLabel.text = NSDecimalNumber(double: risk / 100.0).percentString()

            riskStepper = cell.stepper
            riskLabel = cell.supportLabel
        } else {
            cell.titleLabel.text = "Maximum Position Size"
            cell.stepper.minimumValue = 0
            cell.stepper.maximumValue = 100
            cell.stepper.stepValue = 1
            cell.stepper.value = size
            cell.stepper.tag = Config.sizeTag

            cell.supportLabel.text = NSDecimalNumber(double: size / 100).percentString()

            sizeStepper = cell.stepper
            sizeLabel = cell.supportLabel
        }

        cell.stepper.addTarget(self, action: "stepperChanged:", forControlEvents: .ValueChanged)

        cell.setNeedsUpdateConstraints()
        
        return cell
    }

    // MARK: - UITableViewDelegate Methods

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 3 {
            Flurry.logEvent(
                AnalyticsKeys.resetTradingStyle,
                withParameters: [ "style": properties.profile.toRaw() ]
            )

            if let stepper = riskStepper {
                stepper.value = properties.defaultRisk
                stepperChanged(stepper)
            }

            if let stepper = sizeStepper {
                stepper.value = properties.defaultSize
                stepperChanged(stepper)
            }
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 44.0

        if indexPath.section == 0 || indexPath.section == 1 {
            height = StepperCell.defaultHeight
        }

        return height
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var title: String?
        if section == 0 {
            title = "How much risk can you tolerate as a percentage of your account balance? Common values used by professional traders are 0.5%, 1% and 2%."
        } else if section == 1 {
            title = "Limiting the maximum position size on any given trade ensures diversification and limits risk. Most professional traders ensure no single position exceeds 25% of their account balance. Large accounts should use 20% or even 15%."
        } else if section == 2 {
            title = "This will remember the Risk Percent and Maximum Position Size values of the current trading style when you exit the app."
        }
        return title
    }

}
