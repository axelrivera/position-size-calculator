//
//  PriceViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/24/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

enum PriceType {
    case Entry
    case Stop
    case Account
}

struct PriceConfig {
    var priceType: PriceType = .Entry
    var header: String!
    var tradeType: TradeType = .None
    var defaultPrice: NSDecimalNumber!

    var maxDigits: Int {
        get {
            return priceType == .Account ? 12 : 7
        }
    }

    static let currencyScale = -2

    init(header: String!) {
        self.header = header
    }
}

class PriceViewController: UIViewController, UITextFieldDelegate {

    var headerLabel: UILabel!
    var textField: UITextField!

    var tradeTypeLabel: UILabel!
    var tradeTypeSegmentedControl: UISegmentedControl!

    var saveButton: UIButton!
    var cancelButton: UIButton!

    let config: PriceConfig!

    var digits: String!
    var price: NSDecimalNumber = NSDecimalNumber.zero()

    var cancelBlock: ((controller: PriceViewController) -> Void)?
    var saveBlock: ((controller: PriceViewController, price: NSDecimalNumber, tradeType: TradeType) -> Void)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(config: PriceConfig) {
        super.init(nibName: nil, bundle: nil)
        self.config = config

        setDefaultValues()
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tmp = config.defaultPrice {
            price = tmp
        }

        headerLabel = UILabel(frame: CGRectZero)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.textColor = Color.darkGray
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.font = UIFont.systemFontOfSize(20.0)
        headerLabel.textAlignment = .Center

        headerLabel.text = config.header

        self.view.addSubview(headerLabel)

        textField = UITextField(frame: CGRectZero)
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.font = UIFont.systemFontOfSize(32.0)
        textField.textAlignment = .Center
        textField.placeholder = NSDecimalNumber.zero().currencyString()
        textField.clearButtonMode = .WhileEditing
        textField.keyboardType = .NumberPad
        textField.backgroundColor = UIColor.whiteColor()
        textField.textColor = Color.text
        textField.contentVerticalAlignment = .Center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 20.0

        textField.delegate = self

        textField.autoSetDimension(.Height, toSize: 50.0)

        textField.layer.cornerRadius = 4.0

        self.view.addSubview(textField)

        if config.priceType == .Entry {
            tradeTypeLabel = UILabel(frame: CGRectZero)
            tradeTypeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            tradeTypeLabel.backgroundColor = UIColor.clearColor()
            tradeTypeLabel.font = UIFont.systemFontOfSize(16.0)
            tradeTypeLabel.textColor = Color.text

            tradeTypeLabel.text = "Type of Trade?"

            self.view.addSubview(tradeTypeLabel)

            tradeTypeSegmentedControl = UISegmentedControl(items: [ "Long", "Short" ])
            tradeTypeSegmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
            tradeTypeSegmentedControl.setWidth(70.0, forSegmentAtIndex: 0)
            tradeTypeSegmentedControl.setWidth(70.0, forSegmentAtIndex: 1)

            if (config.tradeType == TradeType.Short) {
                tradeTypeSegmentedControl.selectedSegmentIndex = 1
            } else {
                tradeTypeSegmentedControl.selectedSegmentIndex = 0
            }

            self.view.addSubview(tradeTypeSegmentedControl)
        }

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

        textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        textField.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 15.0)

        if config.priceType == .Entry {
            tradeTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField, withOffset: 20.0)
            tradeTypeLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

            tradeTypeSegmentedControl.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
            tradeTypeSegmentedControl.autoAlignAxis(.Horizontal, toSameAxisOfView: tradeTypeLabel)

            tradeTypeLabel.autoPinEdge(.Right, toEdge: .Left, ofView: tradeTypeSegmentedControl, withOffset: 10.0)

            cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: tradeTypeLabel, withOffset: 30.0)
        } else {
            cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField, withOffset: 30.0)
        }

        cancelButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        cancelButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        saveButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withMultiplier: 0.42)
        saveButton.autoPinEdge(.Top, toEdge: .Top, ofView: cancelButton)
        saveButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)

        // Default Values

        if self.price.isGreaterThanDecimalNumber(NSDecimalNumber.zero()) {
            self.textField.text = self.price.currencyString()
        } else {
            self.textField.text = ""
        }

        textField.becomeFirstResponder()
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

    func cancelAction(sender: AnyObject!) {
        self.view.endEditing(true)

        if let block = cancelBlock {
            block(controller: self)
        }
    }

    func saveAction(sender: AnyObject!) {
        self.view.endEditing(true)

        var tradeType: TradeType

        if config.priceType == .Entry {
            if (tradeTypeSegmentedControl.selectedSegmentIndex == 1) {
                tradeType = .Short
            } else {
                tradeType = .Long
            }
        } else {
            tradeType = .None
        }

        if let block = saveBlock {
            block(controller: self, price: price, tradeType: tradeType)
        }
    }

    // MARK: - UITextFieldDelegate Methods

    func textFieldDidBeginEditing(textField: UITextField!) {
        if price.isGreaterThanDecimalNumber(NSDecimalNumber.zero()) {
            let power = abs(PriceConfig.currencyScale)
            let digitsNumber: NSDecimalNumber = price.decimalNumberByMultiplyingByPowerOf10(Int16(power))
            digits = digitsNumber.stringValue
        }
    }

    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string == "0" && countElements(digits) == 0 {
            return false
        }

        if countElements(string) > 0 {
            if countElements(digits) + 1 <= config.maxDigits {
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
