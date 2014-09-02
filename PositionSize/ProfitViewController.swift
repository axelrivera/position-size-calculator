//
//  ProfitViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/30/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class ProfitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct Config {
        static let CellIdentifier = "Cell"
        static let BreakevenIdentifier = "BreakevenCell"
        static let EmptyIdentifier = "EmptyCell"
    }

    var segmentedControl: UISegmentedControl!
    var tableView: UITableView!

    var position: Position!
    var dataSource: [TableRow] = []

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(position: Position) {
        super.init(nibName: nil, bundle: nil)
        self.position = position
        dataSource = []
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

        segmentedControl = UISegmentedControl(items: [ "Profit", "Loss" ])
        segmentedControl.setWidth(80.0, forSegmentAtIndex: 0)
        segmentedControl.setWidth(80.0, forSegmentAtIndex: 1)

        self.navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.addTarget(self, action: "segmentedControlChanged:", forControlEvents: .ValueChanged)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "doneAction:")

        tableView.backgroundColor = Color.highlight.colorWithAlphaComponent(0.1)

        var headerView = ProfitHeaderView(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, ProfitHeaderView.defaultHeight))

        let isApproved = position.isApproved

        if isApproved {
            headerView.sharesView.detailTextLabel.text = "Shares"
            headerView.riskView.detailTextLabel.text = "Total Risk"
        } else {
            headerView.sharesView.detailTextLabel.text = "Allowed Shares"
            headerView.riskView.detailTextLabel.text = "Total Allowed Risk"
        }

        headerView.tradeTypeLabel.text = position.tradeTypeString().uppercaseString
        headerView.entryView.textLabel.text = position.entryPriceString()
        headerView.stopView.textLabel.text = position.stopPriceString()
        headerView.sharesView.textLabel.text = position.allowedNumberOfSharesString()
        headerView.riskView.textLabel.text = position.allowedRiskString()
        
        headerView.setNeedsDisplay()

        self.tableView.tableHeaderView = headerView

        // AutoLayout

        self.tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
        self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)

        // Default Values

        updateDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Selector Methods

    func doneAction(sender: AnyObject!) {
        self.navigationController.dismissViewControllerAnimated(true, completion: nil)
    }

    func segmentedControlChanged(segmentedControl: UISegmentedControl) {
        updateDataSource()
    }

    // MARK: - Private Methods

    private func updateDataSource() {
        var dictionary: TableData
        var rows: [TableRow] = []

        var shares: NSDecimalNumber! = position.allowedNumberOfShares()
        if shares == nil {
            shares = NSDecimalNumber.zero()
        }

        if shares.isEqualToZero() {
            dataSource = [ TableRow(data: [ "type" : "empty" ]) ]
            tableView.reloadData()
            return
        }

        var breakevenPrice: NSDecimalNumber! = position.breakevenPricePerShare()
        if breakevenPrice == nil {
            breakevenPrice = NSDecimalNumber.zero()
        }

        var riskPerShare: NSDecimalNumber! = position.riskPerShare()
        if riskPerShare == nil {
            riskPerShare = NSDecimalNumber.zero()
        }

        var investment: NSDecimalNumber! = position.allowedTotalInvestment()
        if investment == nil {
            investment = NSDecimalNumber.zero()
        }

        dictionary = [
            "type" : "breakeven",
            "text" : "Breakeven",
            "detail" : breakevenPrice.currencyString(),
        ]

        rows.append(TableRow(data: dictionary))

        var isLoss = segmentedControl.selectedSegmentIndex == 1
        var isLong = position.tradeType == TradeType.Long
        let maxRisk = Int(AppConfig.profitLossRMultiple)

        for i in 1...maxRisk {
            var decorationStr: String
            var decorationColor: UIColor
            var riskStr: String
            var perShareStr: String
            var totalStr: String
            var totalColor: UIColor

            var factor = NSDecimalNumber(integer: i)
            var risk = riskPerShare.decimalNumberByMultiplyingBy(factor)
            var perShare: NSDecimalNumber
            var profitLoss: NSDecimalNumber
            var totalTitle: String
            var totalPerShare: NSDecimalNumber
            var profitPercent: NSDecimalNumber

            riskStr = risk.currencyString()

            if isLoss {
                decorationStr = "-\(i)R"
                decorationColor = Color.darkRed
                totalPerShare = risk.decimalNumberByMultiplyingBy(NSDecimalNumber(double: -1))

                if isLong {
                    perShare = breakevenPrice.decimalNumberBySubtracting(risk)

                    if !perShare.isEqualToZero() {
                        let tmp = perShare.decimalNumberByDividingBy(breakevenPrice)
                        profitPercent = NSDecimalNumber.one().decimalNumberBySubtracting(tmp)
                    } else {
                        profitPercent = NSDecimalNumber.zero()
                    }
                } else {
                    perShare = breakevenPrice.decimalNumberByAdding(risk)

                    if !breakevenPrice.isEqualToZero() {
                        let tmp = perShare.decimalNumberByDividingBy(breakevenPrice)
                        profitPercent = tmp.decimalNumberBySubtracting(NSDecimalNumber.one())
                    } else {
                        profitPercent = NSDecimalNumber.zero()
                    }
                }

                totalColor = Color.darkRed
                totalTitle = "Potential Loss"
            } else {
                decorationStr = "\(i)R"
                decorationColor = Color.darkGreen
                totalPerShare = risk

                if isLong {
                    perShare = breakevenPrice.decimalNumberByAdding(risk)

                    if !breakevenPrice.isEqualToZero() {
                        let tmp = perShare.decimalNumberByDividingBy(breakevenPrice)
                        profitPercent = tmp.decimalNumberBySubtracting(NSDecimalNumber.one())
                    } else {
                        profitPercent = NSDecimalNumber.zero()
                    }
                } else {
                    perShare = breakevenPrice.decimalNumberBySubtracting(risk)

                    if !perShare.isEqualToZero() {
                        let tmp = perShare.decimalNumberByDividingBy(breakevenPrice)
                        profitPercent = NSDecimalNumber.one().decimalNumberBySubtracting(tmp)
                    } else {
                        profitPercent = NSDecimalNumber.zero()
                    }
                }

                totalColor = Color.darkGreen
                totalTitle = "Expected Profit"
            }

            println("total per share: \(totalPerShare)")

            riskStr = risk.currencyString()
            perShareStr = perShare.currencyString()
            profitLoss = totalPerShare.decimalNumberByMultiplyingBy(shares)
            totalStr = "\(profitLoss.currencyString()) (\(profitPercent.percentString()))"

            if perShare.isGreaterThanDecimalNumber(NSDecimalNumber.zero()) {
                dictionary = [
                    "type" : "profit",
                    "decoration" : decorationStr,
                    "decoration_color" : decorationColor,
                    "risk" : riskStr,
                    "per_share_title" : "Share Price",
                    "per_share" : perShareStr,
                    "total_title" : totalTitle,
                    "total" : totalStr,
                    "total_color" : totalColor
                ]

                rows.append(TableRow(data: dictionary))
            }
        }

        dataSource = rows
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        return dataSource.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let dictionary = dataSource[indexPath.row].data
        let typeStr = dictionary["type"] as AnyObject! as String!

        if typeStr == "empty" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.BreakevenIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.BreakevenIdentifier)

                var textLabel = UILabel(frame: CGRectMake(0.0, 0.0, tableView.bounds.size.width - 20.0, 20.0))
                textLabel.textColor = Color.text
                textLabel.font = UIFont.systemFontOfSize(15.0)
                textLabel.textAlignment = .Center
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.text = "No Data Available"

                cell.accessoryView = textLabel
            }

            cell.selectionStyle = .None

            return cell
        }

        if typeStr == "breakeven" {
            var cell = tableView.dequeueReusableCellWithIdentifier(Config.BreakevenIdentifier) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: Config.BreakevenIdentifier)

                cell.textLabel.textColor = Color.chocolate
                cell.textLabel.font = UIFont(name: "Verdana-Bold", size: 22.0)

                cell.detailTextLabel.textColor = UIColor.blackColor()
                cell.detailTextLabel.font = UIFont.systemFontOfSize(16.0)
            }

            let textStr = dictionary["text"] as AnyObject! as String!
            let detailStr = dictionary["detail"] as AnyObject! as String!

            cell.textLabel.text = textStr
            cell.detailTextLabel.text = detailStr

            cell.selectionStyle = .None
            cell.accessoryType = .None

            return cell
        }


        var cell = tableView.dequeueReusableCellWithIdentifier(Config.CellIdentifier) as ProfitCell!
        if cell == nil {
            cell = ProfitCell(reuseIdentifier: Config.CellIdentifier)
        }

        let decorationStr = dictionary["decoration"] as AnyObject! as String!
        let decorationColor = dictionary["decoration_color"] as AnyObject! as UIColor!
        let riskStr = dictionary["risk"] as AnyObject! as String!
        let perShareTitleStr = dictionary["per_share_title"] as AnyObject! as String!
        let perShareStr = dictionary["per_share"] as AnyObject! as String!
        let totalTitleStr = dictionary["total_title"] as AnyObject! as String!
        let totalStr = dictionary["total"] as AnyObject! as String!
        let totalColor = dictionary["total_color"] as AnyObject! as UIColor!

        cell.decorationLabel.textColor = decorationColor
        cell.decorationLabel.text = decorationStr

        cell.riskLabel.text = riskStr

        cell.shareTitleLabel.text = perShareTitleStr
        cell.shareLabel.text = perShareStr

        cell.totalTitleLabel.text = totalTitleStr
        cell.totalLabel.text = totalStr
        cell.totalLabel.textColor = totalColor

        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        
        return cell
    }

    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return ProfitCell.defaultHeight
    }

}
