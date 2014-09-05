//
//  SettingsViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/14/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    struct Config {
        static let CellIdentifier = "Cell"
        static let TradingIdentifier = "TradingCell"
        static let CommissionIdentifier = "CommissionCell"
        static let CommissionSwitchIdentifier = "CommissionSwitchCell"
        static let ProfitIdentifier = "ProfitCell"
    }

    var commissionSwitch: UISwitch!

    weak var profitLabel: UILabel?
    weak var profitStepper: UIStepper?

    var dataSource: [TableSection] = []

    var completionBlock: (() -> Void)?

    override func loadView() {
        self.tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = Color.ultraLightPurple
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "doneAction:"
        )

        // Views inside UITableViewCells

        commissionSwitch = UISwitch(frame: CGRectZero)
        commissionSwitch.setOn(AppConfig.enableCommisions, animated: false)
        commissionSwitch.tintColor = Color.highlight
        commissionSwitch.onTintColor = Color.highlight

        commissionSwitch.addTarget(self, action: "commissionChanged:", forControlEvents: .ValueChanged)

        // Default Values

        updateDataSource(reload: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func doneAction(sender: AnyObject!) {
        if let stepper = profitStepper {
            if AppConfig.profitLossRMultiple != stepper.value {
                Flurry.logEvent(AnalyticsKeys.updateRMultiple)
            }
        }

        if let block = completionBlock {
            block()
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func commissionChanged(mySwitch: UISwitch) {
        AppConfig.enableCommisions = mySwitch.on

        if AppConfig.enableCommisions {
            Flurry.logEvent(AnalyticsKeys.enableCommissions)
        } else {
            Flurry.logEvent(AnalyticsKeys.disableCommissions)
        }

        let indexPaths = [
            NSIndexPath(forRow: 1, inSection: 1),
            NSIndexPath(forRow: 2, inSection: 1)
        ]

        // FIXME: Animation Broken in Beta 7
        updateDataSource(reload: true)

//        self.tableView.beginUpdates()
//
//        if AppConfig.enableCommisions {
//            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//        } else {
//            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//        }
//
//        self.tableView.endUpdates()
    }

    func stepperChanged(stepper: UIStepper) {
        AppConfig.profitLossRMultiple = stepper.value

        if let label = profitLabel {
            label.text = "\(stepper.value)"
        }
    }

    // MARK: - Public Methods

    func updateDataSource(#reload: Bool) {
        var dictionary: TableData

        var sections = [TableSection]()
        var rows = [TableRow]()

        dictionary = [ "type": "text", "text": "General Guide", "subtype": "guide" ]
        rows.append(TableRow(data: dictionary))

        sections.append(TableSection(title: nil, rows: rows))

        rows = []

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
            } else {
                entryCommission = NSDecimalNumber.zero().currencyString()
            }

            dictionary = [ "type": "commission", "text": "Entry", "detail": entryCommission, "subtype": "entry" ]
            rows.append(TableRow(data: dictionary))

            var exitCommission: NSString!
            if let commission = AppConfig.exitCommission {
                exitCommission = commission.currencyString()
            } else {
                exitCommission = NSDecimalNumber.zero().currencyString()
            }

            dictionary = [ "type": "commission", "text": "Exit", "detail": exitCommission, "subtype": "exit" ]
            rows.append(TableRow(data: dictionary))
        }

        sections.append(TableSection(title: "Commissions", rows: rows))

        rows = []

        dictionary = [ "type": "profit_loss", "text": "R Multiple" ]

        var profitRow = TableRow(data: dictionary)
        profitRow.height = StepperCell.defaultHeight

        rows.append(profitRow)

        var profitSection = TableSection(title: "Profit / Loss", rows: rows)
        profitSection.footer = "Maximum R Multiple for Profits & Losses"

        sections.append(profitSection)

        dataSource = sections

        if reload {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dictionary = dataSource[indexPath.section].rows[indexPath.row].data

        let typeStr = dictionary["type"] as AnyObject! as String!
        let subtypeStr = dictionary["subtype"] as AnyObject! as String!

        if typeStr == "text" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.CellIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: Config.CellIdentifier)
            }

            let textStr = dictionary["text"] as AnyObject! as String!

            cell.textLabel?.text = textStr

            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator

            return cell
        }

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
                cell.textLabel?.font = UIFont.systemFontOfSize(16.0)

                cell.accessoryView = commissionSwitch
            }

            cell.textLabel?.text = "Enable Commissions"

            cell.selectionStyle = .None

            return cell
        }

        if typeStr == "commission" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.CommissionIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.CommissionIdentifier)
                cell.textLabel?.font = UIFont.systemFontOfSize(16.0)
                cell.detailTextLabel?.font = UIFont.systemFontOfSize(15.0)
            }

            let textStr = dictionary["text"] as AnyObject! as String!
            let detailStr = dictionary["detail"] as AnyObject! as String!

            cell.textLabel?.text = textStr
            cell.detailTextLabel?.text = detailStr

            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator

            return cell
        }

        if typeStr == "profit_loss" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.ProfitIdentifier) as StepperCell!
            if cell == nil {
                cell = StepperCell(reuseIdentifier: Config.ProfitIdentifier)
            }

            let textStr = dictionary["text"] as AnyObject! as String!

            cell.titleLabel.text = textStr

            cell.stepper.minimumValue = 5
            cell.stepper.maximumValue = 25
            cell.stepper.stepValue = 1
            cell.stepper.value = AppConfig.profitLossRMultiple

            cell.stepper.addTarget(self, action: "stepperChanged:", forControlEvents: .ValueChanged)

            cell.supportLabel.text = "\(AppConfig.profitLossRMultiple)"

            profitLabel = cell.supportLabel
            profitStepper = cell.stepper

            cell.setNeedsUpdateConstraints()

            return cell
        }

        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }

    // MARK: - TableViewDataSource Methods

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let dictionary = dataSource[indexPath.section].rows[indexPath.row].data
        let typeStr = dictionary["type"] as AnyObject! as String!
        let subtypeStr = dictionary["subtype"] as AnyObject! as String!

        if typeStr == "text" && subtypeStr == "guide" {
            Flurry.logEvent(AnalyticsKeys.selectGeneralGuide)

            var webController = WebViewController(urlString: URLStrings.guide)
            webController.title = "Guide"

            self.navigationController?.pushViewController(webController, animated: true)
            return
        }

        if typeStr == "trading" {
            var title: String!
            var defaultRisk: Double!
            var defaultSize: Double!
            var profile: TraderProfile!

            if subtypeStr == "aggressive" {
                title = "Aggressive"
                profile = .Aggressive
                defaultRisk = AppDefaults.aggressiveRiskPercentage
                defaultSize = AppDefaults.aggressivePositionSize
            } else if subtypeStr == "moderate" {
                title = "Moderate"
                profile = .Moderate
                defaultRisk = AppDefaults.moderateRiskPercentage
                defaultSize = AppDefaults.moderatePositionSize
            } else if subtypeStr == "conservative" {
                title = "Conservative"
                profile = .Conservative
                defaultRisk = AppDefaults.conservativeRiskPercentage
                defaultSize = AppDefaults.conservativePositionSize
            }

            var profileValues = AppConfig.valuesForTraderProfile(profile)
            var properties = TraderProfileProperties(title: title, profile: profile)
            properties.defaultRisk = defaultRisk * 100
            properties.defaultSize = defaultSize * 100
            properties.initialRisk = profileValues.risk.doubleValue * 100
            properties.initialSize = profileValues.size.doubleValue * 100

            let traderController = TraderProfileViewController(properties: properties)

            traderController.saveBlock = { [weak self] (controller: TraderProfileViewController, profile: TraderProfile, risk: Double, size: Double) in
                if let weakSelf = self {

                    Flurry.logEvent(
                        AnalyticsKeys.updateTradingStyle,
                        withParameters: [ "style": profile.toRaw() ]
                    )

                    switch profile {
                    case .Aggressive:
                        AppConfig.aggressiveRiskPercentage = NSDecimalNumber(double: risk / 100)
                        AppConfig.aggressivePositionSize = NSDecimalNumber(double: size / 100)
                    case .Moderate:
                        AppConfig.moderateRiskPercentage = NSDecimalNumber(double: risk / 100)
                        AppConfig.moderatePositionSize = NSDecimalNumber(double: size / 100)
                    case .Conservative:
                        AppConfig.conservativeRiskPercentage = NSDecimalNumber(double: risk / 100)
                        AppConfig.conservativePositionSize = NSDecimalNumber(double: size / 100)
                    default:
                        println("invalid profile")
                    }

                    weakSelf.updateDataSource(reload: true)
                    weakSelf.navigationController?.popViewControllerAnimated(true)
                }
            }

            self.navigationController?.pushViewController(traderController, animated: true)
        }

        if typeStr == "commission" {
            var commissionType: CommissionType!
            var price: NSDecimalNumber!
            var labelStr: String!

            if subtypeStr == "entry" {
                commissionType = .Entry
                price = AppConfig.entryCommission
                labelStr = "Entry Price"
            } else if subtypeStr == "exit" {
                commissionType = .Exit
                price = AppConfig.exitCommission
                labelStr = "Exit Price"
            }

            if price == nil {
                price = NSDecimalNumber.zero()
            }

            var properties = CommissionProperties(title: "Commission", commissionType: commissionType)
            properties.defaultPrice = price
            properties.inputStr = labelStr

            let commissionController = CommissionViewController(properties: properties)

            commissionController.saveBlock = { [weak self] (controller: CommissionViewController, commissionType: CommissionType, price: NSDecimalNumber) in
                if let weakSelf = self {
                    if commissionType == CommissionType.Entry {
                        AppConfig.entryCommission = price
                    } else if commissionType == CommissionType.Exit {
                        AppConfig.exitCommission = price
                    }

                    weakSelf.updateDataSource(reload: true)
                    weakSelf.navigationController?.popViewControllerAnimated(true)
                }
            }

            self.navigationController?.pushViewController(commissionController, animated: true)
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = dataSource[indexPath.section].rows[indexPath.row].height {
            return height
        } else {
            return 44.0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource[section].footer
    }

}
