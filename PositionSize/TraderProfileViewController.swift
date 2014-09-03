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

class TraderProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct Config {
        static let CellIdentifier = "Cell"
        static let ResetIdentifier = "ResetCell"
        static let riskTag = 100
        static let sizeTag = 200
    }

    var tableView: UITableView!

    weak var riskStepper: UIStepper?
    weak var riskLabel: UILabel?

    weak var sizeStepper: UIStepper?
    weak var sizeLabel: UILabel?

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
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()

        self.tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.view.addSubview(self.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Save,
            target: self,
            action: "saveAction:")

        tableView.backgroundColor = Color.highlight.colorWithAlphaComponent(0.1)

        // AutoLayout

        self.tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
        self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
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
                label.text = NSDecimalNumber(double: risk / 100).doublePercentString()
            }
        } else {
            size = stepper.value

            if let label = sizeLabel {
                label.text = NSDecimalNumber(double: size / 100).percentString()
            }
        }
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var rows  = 0

        if section == 0 {
            rows = 2
        } else if section == 1 {
            rows = 1
        }

        return rows
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.ResetIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.ResetIdentifier)

                var textLabel = UILabel(frame: CGRectMake(0.0, 0.0, tableView.bounds.size.width - 20.0, 20.0))
                textLabel.font = UIFont.systemFontOfSize(16.0)
                textLabel.textAlignment = .Center
                textLabel.textColor = Color.red
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.text = "Reset to Default Values"

                cell.accessoryView = textLabel
            }

            cell.selectionStyle = .Default
            
            return cell
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(Config.CellIdentifier) as StepperCell!
        if cell == nil {
            cell = StepperCell(reuseIdentifier: Config.CellIdentifier)
        }

        if indexPath.row == 0 {
            cell.titleLabel.text = "Risk Percentage"
            cell.stepper.minimumValue = 0.0
            cell.stepper.maximumValue = 10.0
            cell.stepper.stepValue = 0.25
            cell.stepper.value = risk
            cell.stepper.tag = Config.riskTag

            cell.supportLabel.text = NSDecimalNumber(double: risk / 100.0).doublePercentString()

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

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 1 {
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

    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var height: CGFloat = 44.0

        if indexPath.section == 0 {
            height = StepperCell.defaultHeight
        }

        return height
    }

}
