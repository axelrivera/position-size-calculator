//
//  SettingsViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/14/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct Config {
        static let TradingIdentifier = "TradingCell"
        static let CommissionIdentifier = "CommissionCell"
        static let CommissionSwitchIdentifier = "CommissionSwitchCell"
        static let ProfitIdentifier = "ProfitCell"
    }

    var tableView: UITableView!
    var commissionSwitch: UISwitch!

    var profitLossStepper: UIStepper!
    var profitLossLabel: UILabel!
    var profitLossView: UIView!

    var dataSource: [TableSection] = []

    var completionBlock: (() -> Void)?

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()

        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Grouped)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        self.title = "Settings"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "doneAction:"
        )

        tableView.backgroundColor = Color.highlight.colorWithAlphaComponent(0.1)

        // Views inside UITableViewCells

        commissionSwitch = UISwitch(frame: CGRectZero)
        commissionSwitch.setOn(AppConfig.enableCommisions, animated: false)
        commissionSwitch.tintColor = Color.highlight
        commissionSwitch.onTintColor = Color.highlight

        commissionSwitch.addTarget(self, action: "commissionChanged:", forControlEvents: .ValueChanged)

        var profitLossStepperFrame: CGRect
        var profitLossLabelFrame: CGRect
        var profitLossFrame: CGRect

        profitLossStepper = UIStepper(frame: CGRectZero)
        profitLossStepper.stepValue = 1
        profitLossStepper.minimumValue = 5.0
        profitLossStepper.maximumValue = 25.0

        profitLossStepper.value = AppConfig.profitLossRMultiple

        profitLossStepper.addTarget(self, action: "stepperChanged:", forControlEvents: .ValueChanged)

        profitLossStepperFrame = profitLossStepper.bounds
        profitLossLabelFrame = CGRectMake(0.0, 0.0, 100.0, profitLossStepperFrame.size.height)

        profitLossLabel = UILabel(frame: profitLossLabelFrame)
        profitLossLabel.font = UIFont.systemFontOfSize(16.0)
        profitLossLabel.textColor = UIColor.blackColor()
        profitLossLabel.textAlignment = .Left
        profitLossLabel.backgroundColor = UIColor.clearColor()

        profitLossLabel.text = "\(AppConfig.profitLossRMultiple)"

        profitLossFrame = CGRectMake(
            0.0,
            0.0,
            profitLossStepperFrame.size.width + profitLossLabelFrame.size.width,
            profitLossStepperFrame.size.height)

        profitLossStepperFrame.origin.x = profitLossLabelFrame.size.width

        profitLossStepper.frame = profitLossStepperFrame
        profitLossLabel.frame = profitLossLabelFrame

        profitLossView = UIView(frame: profitLossFrame)
        profitLossView.backgroundColor = UIColor.clearColor()

        profitLossView.addSubview(profitLossLabel)
        profitLossView.addSubview(profitLossStepper)

        // AutoLayout

        self.tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
        self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)

        // Default Values

        updateDataSource(reload: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func doneAction(sender: AnyObject!) {
        if let block = completionBlock {
            block()
        } else {
            self.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func commissionChanged(mySwitch: UISwitch) {
        AppConfig.enableCommisions = mySwitch.on

        let indexPaths = [
            NSIndexPath(forRow: 1, inSection: 1),
            NSIndexPath(forRow: 2, inSection: 1)
        ]

        updateDataSource(reload: false)

        tableView.beginUpdates()

        if AppConfig.enableCommisions {
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        } else {
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }

        tableView.endUpdates()
    }

    func stepperChanged(stepper: UIStepper) {
        AppConfig.profitLossRMultiple = stepper.value
        profitLossLabel.text = "\(stepper.value)"
    }

    // MARK: - Private Methods

    private func updateDataSource(#reload: Bool) {
        var dictionary: TableData

        var sections = [TableSection]()
        var rows = [TableRow]()

        var aggressiveRisk = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.aggressiveRiskPercentage {
            aggressiveRisk = percent.percentString()
        }

        var aggressiveSize = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.aggressivePositionSize {
            aggressiveSize = percent.percentString()
        }

        dictionary = [
            "type": "trading",
            "title": "Aggressive",
            "risk": aggressiveRisk,
            "size": aggressiveSize,
            "subtype": "aggressive"
        ]

        var aggressiveRow = TableRow(data: dictionary)
        aggressiveRow.height = TradingStyleCell.defaultHeight

        rows.append(aggressiveRow)

        var moderateRisk = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.moderateRiskPercentage {
            moderateRisk = percent.percentString()
        }

        var moderateSize = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.moderatePositionSize {
            moderateSize = percent.percentString()
        }

        dictionary = [
            "type": "trading",
            "title": "Moderate",
            "risk": moderateRisk,
            "size": moderateSize,
            "subtype": "moderate"
        ]

        var moderateRow = TableRow(data: dictionary)
        moderateRow.height = TradingStyleCell.defaultHeight

        rows.append(moderateRow)

        var conservativeRisk = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.conservativeRiskPercentage {
            conservativeRisk = percent.percentString()
        }

        var conservativeSize = NSDecimalNumber.zero().percentString()
        if let percent = AppConfig.conservativePositionSize {
            conservativeSize = percent.percentString()
        }

        dictionary = [
            "type": "trading",
            "title": "Conservative",
            "risk": conservativeRisk,
            "size": conservativeSize,
            "subtype": "conservative"
        ]

        var conservativeRow = TableRow(data: dictionary)
        conservativeRow.height = TradingStyleCell.defaultHeight

        rows.append(conservativeRow)

        sections.append(TableSection(title: "Trading Style", rows: rows))

        rows = []

        dictionary = [ "type": "commission_switch" ]
        rows.append(TableRow(data: dictionary))

        if AppConfig.enableCommisions {
            var entryCommission: NSString!
            if let commission = AppConfig.entryCommission {
                entryCommission = commission.currencyString()
            }

            dictionary = [ "type": "commission", "text": "Entry", "detail": entryCommission, "subtype": "entry" ]
            rows.append(TableRow(data: dictionary))

            var exitCommission: NSString!
            if let commission = AppConfig.exitCommission {
                exitCommission = commission.currencyString()
            }

            dictionary = [ "type": "commission", "text": "Exit", "detail": exitCommission, "subtype": "exit" ]
            rows.append(TableRow(data: dictionary))
        }

        sections.append(TableSection(title: "Commissions", rows: rows))

        rows = []

        dictionary = [ "type": "profit_loss", "text": "R Multiple" ]
        rows.append(TableRow(data: dictionary))

        var profitSection = TableSection(title: "Profit / Loss", rows: rows)
        profitSection.footer = "Maximum R Multiple for Profits & Losses"

        sections.append(profitSection)

        dataSource = sections

        if reload {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return dataSource.count
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let dictionary = dataSource[indexPath.section].rows[indexPath.row].data

        let typeStr = dictionary["type"] as AnyObject! as String!
        let subtypeStr = dictionary["subtype"] as AnyObject! as String!

        if typeStr == "trading" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.TradingIdentifier) as TradingStyleCell!
            if cell == nil {
                cell = TradingStyleCell(reuseIdentifier: Config.TradingIdentifier)
            }

            let titleStr = dictionary["title"] as AnyObject! as String!
            let riskStr = dictionary["risk"] as AnyObject! as String!
            let sizeStr = dictionary["size"] as AnyObject! as String!

            cell.titleLabel.text = titleStr
            cell.riskLabel.text = riskStr
            cell.sizeLabel.text = sizeStr

            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator

            cell.setNeedsUpdateConstraints()

            return cell
        }

        if typeStr == "commission_switch" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.CommissionSwitchIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.CommissionSwitchIdentifier)
                cell.textLabel.font = UIFont.systemFontOfSize(16.0)

                cell.accessoryView = commissionSwitch
            }

            cell.textLabel.text = "Enable Commissions"

            cell.selectionStyle = .None

            return cell
        }

        if typeStr == "commission" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.CommissionIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.CommissionIdentifier)
                cell.textLabel.font = UIFont.systemFontOfSize(16.0)
                cell.detailTextLabel.font = UIFont.systemFontOfSize(15.0)
            }

            let textStr = dictionary["text"] as AnyObject! as String!
            let detailStr = dictionary["detail"] as AnyObject! as String!

            cell.textLabel.text = textStr
            cell.detailTextLabel.text = detailStr

            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator

            return cell
        }

        if typeStr == "profit_loss" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.ProfitIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.ProfitIdentifier)
                cell.textLabel.font = UIFont.systemFontOfSize(15.0)

                cell.accessoryView = profitLossView
            }

            let textStr = dictionary["text"] as AnyObject! as String!

            cell.textLabel.text = textStr
            cell.selectionStyle = .None

            return cell
        }

        return nil
    }

    // MARK: - TableViewDataSource Methods

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if let height = dataSource[indexPath.section].rows[indexPath.row].height {
            return height
        } else {
            return 44.0
        }
    }

    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return dataSource[section].title
    }

    func tableView(tableView: UITableView!, titleForFooterInSection section: Int) -> String! {
        return dataSource[section].footer
    }

}
