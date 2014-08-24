//
//  SummaryView.swift
//  PositionSize
//
//  Created by Axel Rivera on 8/17/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

enum SummaryViewStatus {
    case None, Approved, NotApproved
}

class SummaryView: UIView, UIScrollViewDelegate {
    
    struct Config {
        static let verticalPadding: CGFloat = 10.0
        static let horizontalPadding: CGFloat = 10.0
        static let nameHeight: CGFloat = 18.0
    }

    var tradePanel: SummaryDetailView!
    var allowedTradePanel: SummaryDetailView!

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!

    var status: SummaryViewStatus!

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
        pageControl.defersCurrentPageDisplay = true

        self.addSubview(pageControl)

        tradePanel = SummaryDetailView(frame: CGRectZero)
        allowedTradePanel = SummaryDetailView(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentSize = self.bounds.size
        let scrollFrame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
        let pageFrame = CGRectMake(0.0, contentSize.height - 20.0, contentSize.width, 20.0)

        scrollView.frame = scrollFrame
        pageControl.frame = pageFrame

        if updateScrollPanels {
            updateScrollPanels = false

            if status == .NotApproved {
                scrollView.contentSize = CGSizeMake(contentSize.width * 2.0, contentSize.height)
                tradePanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
                allowedTradePanel.frame = CGRectMake(contentSize.width, 0.0, contentSize.width, contentSize.height)
            } else {
                scrollView.contentSize = contentSize
                tradePanel.frame = CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)
            }
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

        if status == .NotApproved {
            pageControl.numberOfPages = 2

            tradePanel.titleLabel.text = "NOT APPROVED"
            tradePanel.leftDetailLabel.text = "Shares"
            tradePanel.rightDetailLabel.text = "Cost of Trade"

            tradePanel.backgroundColor = Color.red

            scrollView.addSubview(tradePanel)

            allowedTradePanel.titleLabel.text = "ALLOWED"
            allowedTradePanel.leftDetailLabel.text = "Allowed Shares"
            allowedTradePanel.rightDetailLabel.text = "Allowed Cost of Trade"

            allowedTradePanel.backgroundColor = Color.orange

            scrollView.addSubview(allowedTradePanel)
        } else {
            pageControl.numberOfPages = 1

            if status == .Approved {
                tradePanel.titleLabel.text = "APPROVED"
                tradePanel.backgroundColor = Color.green
            } else {
                tradePanel.titleLabel.text = "RESULTS"
                tradePanel.leftTextLabel.text = "0"
                tradePanel.rightTextLabel.text = "$0.00"
                tradePanel.backgroundColor = Color.lightGray
            }

            tradePanel.leftDetailLabel.text = "Shares"
            tradePanel.rightDetailLabel.text = "Cost of Trade"

            scrollView.addSubview(tradePanel)
        }

        if status == .None {
            tradePanel.titleLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            tradePanel.leftTextLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            tradePanel.leftDetailLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            tradePanel.rightTextLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            tradePanel.rightDetailLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        } else {
            tradePanel.titleLabel.textColor = UIColor.whiteColor()
            tradePanel.leftTextLabel.textColor = UIColor.whiteColor()
            tradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
            tradePanel.rightTextLabel.textColor = UIColor.whiteColor()
            tradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.9)

            if (status == .NotApproved) {
                allowedTradePanel.titleLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.leftTextLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.leftDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
                allowedTradePanel.rightTextLabel.textColor = UIColor.whiteColor()
                allowedTradePanel.rightDetailLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
            }
        }

        scrollView.backgroundColor = tradePanel.backgroundColor

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

    // MARK: - UIScrollViewDelegate Methods

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Switch the indicator when more than 50% of the previous/next page is visible

        let pageWidth = scrollView.bounds.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1)
        pageControl.currentPage = page

        if page == 0 {
            scrollView.backgroundColor = tradePanel.backgroundColor
        } else if page == 1 {
            scrollView.backgroundColor = allowedTradePanel.backgroundColor
        } else {
            scrollView.backgroundColor = Color.ultraLightGray
        }
    }
}
