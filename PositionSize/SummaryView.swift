//
//  SummaryView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/17/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

enum SummaryViewStatus {
    case None, Approved, NotApproved, Error
}

class SummaryView: UIView, UIScrollViewDelegate {
    
    struct Config {
        static let verticalPadding: CGFloat = 10.0
        static let horizontalPadding: CGFloat = 10.0
        static let nameHeight: CGFloat = 18.0
        static let profitButtonSize: CGSize = CGSizeMake(31.0, 22.0)
        static let resetButtonSize: CGSize = CGSizeMake(20.0, 25.0)
    }

    var profitButton: UIButton!
    var resetButton: UIButton!

    var tradePanel: SummaryDetailView!
    var allowedTradePanel: SummaryDetailView!
    var riskPanel: SummaryDetailView!
    var errorPanel: SummaryMessageView!

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!

    var status: SummaryViewStatus!

    var pageControlUsed: Bool = false

    private var updateScrollPanels: Bool = false

    override required init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(white: 0.85, alpha: 1.0)

        status = .None

        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.delegate = self

        self.addSubview(scrollView)

        pageControl = UIPageControl(frame: CGRectZero)
        pageControl.numberOfPages = 2
        pageControl.hidesForSinglePage = true

        pageControl.addTarget(self, action: "pageChanged:", forControlEvents: .ValueChanged)

        self.addSubview(pageControl)

        profitButton = UIButton.buttonWithType(.System) as UIButton
        profitButton.setImage(UIImage(named: "money"), forState: .Normal)
        profitButton.tintColor = UIColor.whiteColor()

        self.addSubview(profitButton)

        resetButton = UIButton.buttonWithType(.System) as UIButton
        resetButton.setImage(UIImage(named: "reload"), forState: .Normal)
        resetButton.tintColor = UIColor.whiteColor()

        self.addSubview(resetButton)

        tradePanel = SummaryDetailView(frame: CGRectZero)
        allowedTradePanel = SummaryDetailView(frame: CGRectZero)
        riskPanel = SummaryDetailView(frame: CGRectZero)
        errorPanel = SummaryMessageView(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentSize = self.bounds.size
        let scrollFrame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
        let pageFrame = CGRectMake(0.0, contentSize.height - 20.0, contentSize.width, 20.0)

        let profitButtonFrame = CGRectMake(
            15.0,
            9.0,
            Config.profitButtonSize.width,
            Config.profitButtonSize.height)

        let resetButtonFrame = CGRectMake(
            contentSize.width - (Config.resetButtonSize.width + 15.0),
            7.0,
            Config.resetButtonSize.width,
            Config.resetButtonSize.height)

        scrollView.frame = scrollFrame
        pageControl.frame = pageFrame
        profitButton.frame = profitButtonFrame
        resetButton.frame = resetButtonFrame

        if updateScrollPanels {
            updateScrollPanels = false

            if status == .Error {
                scrollView.contentSize = contentSize
                errorPanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
            } else {
                if status == .Approved {
                    scrollView.contentSize = CGSizeMake(contentSize.width * 2.0, contentSize.height)
                    tradePanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
                    riskPanel.frame = CGRectMake(contentSize.width, 0.0, contentSize.width, contentSize.height)
                } else if status == .NotApproved {
                    scrollView.contentSize = CGSizeMake(contentSize.width * 3.0, contentSize.height)
                    tradePanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
                    allowedTradePanel.frame = CGRectMake(contentSize.width, 0.0, contentSize.width, contentSize.height)
                    riskPanel.frame = CGRectMake(contentSize.width * 2.0, 0.0, contentSize.width, contentSize.height)
                } else {
                    scrollView.contentSize = contentSize
                    tradePanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
                }
            }

            scrollView.scrollRectToVisible(scrollFrame, animated: false)
        }
    }

    func setStatus(status: SummaryViewStatus) {
        self.status = status

        if let view = tradePanel.superview {
            tradePanel.removeFromSuperview()
        }

        if let view = allowedTradePanel.superview {
            allowedTradePanel.removeFromSuperview()
        }

        if let view = riskPanel.superview {
            riskPanel.removeFromSuperview()
        }

        if let view = errorPanel.superview {
            errorPanel.removeFromSuperview()
        }

        if status == .Error {
            self.showResetButton(animated: false)
            self.hideProfitButton(animated: false)

            pageControl.numberOfPages = 1

            errorPanel.titleLabel.text = "ERROR"
            errorPanel.backgroundColor = Color.red

            scrollView.addSubview(errorPanel)
        } else if status == .Approved {
            self.showResetButton(animated: false)
            self.showProfitButton(animated: false)

            pageControl.numberOfPages = 2

            tradePanel.titleLabel.text = "APPROVED"
            tradePanel.backgroundColor = Color.green

            tradePanel.leftDetailLabel.text = "Shares"
            tradePanel.rightDetailLabel.text = "Cost of Trade"

            scrollView.addSubview(tradePanel)

            riskPanel.titleLabel.text = "APPROVED RISK"
            riskPanel.leftDetailLabel.text = "Percentage of Risk"
            riskPanel.rightDetailLabel.text = "Total Approved Risk"

            riskPanel.backgroundColor = Color.orange

            scrollView.addSubview(riskPanel)
        } else if status == .NotApproved {
            self.showResetButton(animated: false)
            self.showProfitButton(animated: false)

            pageControl.numberOfPages = 3

            tradePanel.titleLabel.text = "NOT APPROVED"
            tradePanel.leftDetailLabel.text = "Shares"
            tradePanel.rightDetailLabel.text = "Cost of Trade"

            tradePanel.backgroundColor = Color.red

            scrollView.addSubview(tradePanel)

            allowedTradePanel.titleLabel.text = "ALLOWED"
            allowedTradePanel.leftDetailLabel.text = "Allowed Shares"
            allowedTradePanel.rightDetailLabel.text = "Allowed Cost of Trade"

            allowedTradePanel.backgroundColor = Color.green

            scrollView.addSubview(allowedTradePanel)

            riskPanel.titleLabel.text = "ALLOWED RISK"
            riskPanel.leftDetailLabel.text = "Percentage of Risk"
            riskPanel.rightDetailLabel.text = "Total Allowed Risk"

            riskPanel.backgroundColor = Color.orange

            scrollView.addSubview(riskPanel)
        } else {
            pageControl.numberOfPages = 1

            self.hideResetButton(animated: false)
            self.hideProfitButton(animated: false)

            tradePanel.titleLabel.text = "RESULTS"
            tradePanel.leftTextLabel.text = "0"
            tradePanel.rightTextLabel.text = "$0.00"
            tradePanel.backgroundColor = Color.lightGray

            tradePanel.leftDetailLabel.text = "Shares"
            tradePanel.rightDetailLabel.text = "Cost of Trade"

            scrollView.addSubview(tradePanel)
        }

        if status == .Error {
            errorPanel.titleLabel.textColor = UIColor.whiteColor()
            errorPanel.textLabel.textColor = UIColor(white: 1.0, alpha: 0.7)

            scrollView.backgroundColor = errorPanel.backgroundColor
        } else {
            if status == .None {
                tradePanel.titleLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                tradePanel.leftTextLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                tradePanel.leftDetailLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
                tradePanel.rightTextLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                tradePanel.rightDetailLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
            } else {
                tradePanel.titleLabel.textColor = UIColor.whiteColor()
                tradePanel.leftTextLabel.textColor = UIColor.whiteColor()
                tradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
                tradePanel.rightTextLabel.textColor = UIColor.whiteColor()
                tradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)

                allowedTradePanel.titleLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.leftTextLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
                allowedTradePanel.rightTextLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)

                riskPanel.titleLabel.textColor = UIColor.whiteColor()
                riskPanel.leftTextLabel.textColor = UIColor.whiteColor()
                riskPanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
                riskPanel.rightTextLabel.textColor = UIColor.whiteColor()
                riskPanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)

                if status == .Approved {
                    tradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
                    tradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
                } else if status == .NotApproved {
                    allowedTradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
                    allowedTradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
                }
            }
            
            scrollView.backgroundColor = tradePanel.backgroundColor
        }

        updateScrollPanels = true
        self.setNeedsLayout()
    }

    func setShares(shares: NSString!) {
        tradePanel.leftTextLabel.text = shares
    }

    func setTradeCost(cost: NSString!) {
        tradePanel.rightTextLabel.text = cost
    }

    func setAllowedShares(shares: NSString!) {
        allowedTradePanel.leftTextLabel.text = shares
    }

    func setAllowedTradeCost(cost: NSString!) {
        allowedTradePanel.rightTextLabel.text = cost
    }

    func setAllowedRiskPercent(percent: NSString!) {
        riskPanel.leftTextLabel.text = percent
    }

    func setAllowedRisk(risk: NSString!) {
        riskPanel.rightTextLabel.text = risk
    }

    func setErrorText(text: NSString!) {
        errorPanel.textLabel.text = text
    }

    func showProfitButton(#animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.profitButton.alpha = 1.0
        })
    }

    func hideProfitButton(#animated: Bool) {
        let duration = animated ? 0.1 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.profitButton.alpha = 0.0
        })
    }

    func showResetButton(#animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.resetButton.alpha = 1.0
        })
    }

    func hideResetButton(#animated: Bool) {
        let duration = animated ? 0.1 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.resetButton.alpha = 0.0
        })
    }

    // MARK: - Selector Methods

    func pageChanged(pageControl: UIPageControl) {
        let page: CGFloat = CGFloat(pageControl.currentPage)

        var frame = scrollView.frame
        frame.origin.x = frame.size.width * page
        frame.origin.y = 0.0

        self.hideResetButton(animated: true)
        self.hideProfitButton(animated: true)

        scrollView.scrollRectToVisible(frame, animated: true)
        pageControlUsed = true;
    }

    // MARK: - UIScrollViewDelegate Methods

    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        self.hideResetButton(animated: true)
        self.hideProfitButton(animated: true)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        self.showResetButton(animated: true)
        self.showProfitButton(animated: true)
        pageControlUsed = false
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView!) {
        self.showResetButton(animated: true)
        self.showProfitButton(animated: true)
        pageControlUsed = false
    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Switch the indicator when more than 50% of the previous/next page is visible

        if pageControlUsed {
            return
        }

        let pageWidth = scrollView.bounds.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1)
        pageControl.currentPage = page

        if page == 0 {
            scrollView.backgroundColor = tradePanel.backgroundColor
        } else if page == 1 {
            if status == .Approved {
                scrollView.backgroundColor = riskPanel.backgroundColor
            } else {
                scrollView.backgroundColor = allowedTradePanel.backgroundColor
            }
        } else if page == 2 {
            scrollView.backgroundColor = riskPanel.backgroundColor
        } else {
            scrollView.backgroundColor = Color.ultraLightGray
        }
    }
    
}
