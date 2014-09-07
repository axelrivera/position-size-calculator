//
//  WebViewController.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/3/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!
    var urlString: String = "http://localhost"

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(urlString: String) {
        super.init(nibName: nil, bundle: nil)
        self.urlString = urlString
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = Color.background

        webView = UIWebView(frame: CGRectZero)
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        webView.delegate = self

        self.view.addSubview(webView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        var request = NSURLRequest(URL: NSURL(string: urlString))
        webView.loadRequest(request)

        // AutoLayout

        webView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
        webView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIWebViewDelegate Methods

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked && UIApplication.sharedApplication().canOpenURL(request.URL) {
            UIApplication.sharedApplication().openURL(request.URL)
            return false
        }
        return true
    }

}
