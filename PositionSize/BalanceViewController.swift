//
//  BalanceViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/28/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

struct BalanceConfig {
    var header: String!
    var defaultPrice: NSDecimalNumber!

    static let maxDigits = 12
    static let currencyScale = -2

    init(header: String!) {
        self.header = header
    }
}

class BalanceViewController: UIViewController, UITextFieldDelegate {

    var headerLabel: UILabel!
    var textField: UITextField!

    var clearButton: UIButton!
    var saveButton: UIButton!
    var cancelButton: UIButton!

    let config: BalanceConfig!

    var digits: String!
    var price: NSDecimalNumber = NSDecimalNumber.zero()

    var cancelBlock: ((controller: BalanceViewController) -> Void)?
    var saveBlock: ((controller: BalanceViewController, price: NSDecimalNumber) -> Void)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(config: BalanceConfig) {
        super.init(nibName: nil, bundle: nil)
        self.config = config

        setDefaultValues()
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        price = config.defaultPrice

        headerLabel = UILabel(frame: CGRectZero)
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.font = UIFont.systemFontOfSize(12.0)
        headerLabel.textColor = Color.text
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.textAlignment = .Left

        headerLabel.text = "Account Balance"

        self.view.addSubview(headerLabel)

        textField = UITextField(frame: CGRectZero)
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.font = UIFont.systemFontOfSize(36.0)
        textField.textAlignment = .Center
        textField.textColor = Color.header
        textField.placeholder = NSDecimalNumber.zero().currencyString()
        textField.keyboardType = .NumberPad
        textField.backgroundColor = UIColor.clearColor()
        textField.textColor = Color.text
        textField.contentVerticalAlignment = .Center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12.0

        textField.delegate = self

        textField.autoSetDimension(.Height, toSize: 46.0)

        self.view.addSubview(textField)

        let lineView = UIView(frame: CGRectZero)
        lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineView.backgroundColor = Color.border

        lineView.autoSetDimension(.Height, toSize: 0.5)

        self.view.addSubview(lineView)

        clearButton = UIButton.buttonWithType(.System) as UIButton
        clearButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        clearButton.setTitle("Clear Account Size", forState: .Normal)

        clearButton.addTarget(self, action: "clearAction:", forControlEvents: .TouchUpInside)

        self.view.addSubview(clearButton)

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

        headerLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        headerLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)

        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 8.0)
        textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        textField.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)

        lineView.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField, withOffset: 5.0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)

        clearButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView, withOffset: 10.0)
        clearButton.autoAlignAxisToSuperviewAxis(.Vertical)

        cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: clearButton, withOffset: 20.0)
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logPageView()
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

        if let block = saveBlock {
            block(controller: self, price: price)
        }
    }

    func clearAction(sender: AnyObject!) {
        textField.text = ""
        setDefaultValues()
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
            if countElements(digits) + 1 <= BalanceConfig.maxDigits {
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
            number = decimal.decimalNumberByMultiplyingByPowerOf10(Int16(BalanceConfig.currencyScale))
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
