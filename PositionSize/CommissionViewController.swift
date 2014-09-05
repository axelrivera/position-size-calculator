//
//  CommissionViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/2/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

enum CommissionType {
    case Entry
    case Exit
}

struct CommissionProperties {
    var title: String!
    var commissionType: CommissionType = .Entry
    var inputStr: String! = "Price"
    var defaultPrice: NSDecimalNumber!

    static let maxDigits: Int = 9
    static let currencyScale = -2

    init(title: NSString!, commissionType: CommissionType) {
        self.title = title
        self.commissionType = commissionType
    }
}

class CommissionViewController: UITableViewController, UITextFieldDelegate {

    struct Config {
        static let CellIdentifier = "Cell"
    }

    var textField: UITextField!

    var properties: CommissionProperties!

    var digits: String!
    var price: NSDecimalNumber = NSDecimalNumber.zero()

    var saveBlock: ((controller: CommissionViewController, commissionType: CommissionType, price: NSDecimalNumber) -> Void)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(properties: CommissionProperties) {
        super.init(nibName: nil, bundle: nil)
        self.properties = properties

        self.title = properties.title

        setDefaultValues()
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

        if let tmp = properties.defaultPrice {
            price = tmp
        }

        textField = UITextField(frame: CGRectMake(0.0, 0.0, 190.0, 30.0))
        textField.font = UIFont.systemFontOfSize(17.0)
        textField.textAlignment = .Left
        textField.placeholder = NSDecimalNumber.zero().currencyString()
        textField.clearButtonMode = .WhileEditing
        textField.keyboardType = .NumberPad
        textField.backgroundColor = UIColor.whiteColor()
        textField.textColor = Color.text
        textField.contentVerticalAlignment = .Center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 14.0

        textField.delegate = self

        // Default Values

        if self.price.isGreaterThanDecimalNumber(NSDecimalNumber.zero()) {
            self.textField.text = self.price.currencyString()
        } else {
            self.textField.text = ""
        }

        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Public Methods

    func setDefaultValues() {
        digits = ""
        price = NSDecimalNumber.zero()
    }

    // MARK: - Selector Methods

    func saveAction(sender: AnyObject!) {
        if let block = saveBlock {
            block(controller: self, commissionType: properties.commissionType, price: price)
        }
    }

    // MARK: - UITableViewDataSource Methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Config.CellIdentifier) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: Config.CellIdentifier)
            cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
            cell.accessoryView = textField
        }

        cell.textLabel?.text = properties.inputStr
        cell.selectionStyle = .None

        return cell
    }

    // MARK: - UITableViewDelegate Methods

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.0
    }

    // MARK: - UITextFieldDelegate Methods

    func textFieldDidBeginEditing(textField: UITextField!) {
        if price.isGreaterThanDecimalNumber(NSDecimalNumber.zero()) {
            let power = abs(CommissionProperties.currencyScale)
            let digitsNumber: NSDecimalNumber = price.decimalNumberByMultiplyingByPowerOf10(Int16(power))
            digits = digitsNumber.stringValue
        }
    }

    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string == "0" && countElements(digits) == 0 {
            return false
        }

        if countElements(string) > 0 {
            if countElements(digits) + 1 <= CommissionProperties.maxDigits {
                digits = digits.stringByAppendingString(string)
            }
        } else {
            // This is a backspace
            let length = countElements(digits)
            if length > 1 {
                digits = digits.substringWithRange(Range<String.Index>(start: digits.startIndex, end: digits.endIndex.predecessor()))
            } else {
                digits = ""
            }
        }

        var number = NSDecimalNumber.zero()
        if digits != "" {
            let decimal = NSDecimalNumber(string: digits)
            number = decimal.decimalNumberByMultiplyingByPowerOf10(Int16(PriceConfig.currencyScale))
        }

        price = number
        textField.text = price.currencyString()

        return false
    }

    func textFieldShouldClear(textField: UITextField!) -> Bool {
        setDefaultValues()
        return true
    }

}
