//
//  Table.swift
//  PositionSize
//
//  Created by Axel Rivera on 9/1/14.
//  Copyright (c) 2014 Axel Rivera. All rights reserved.
//

import Foundation

typealias TableData = [String: AnyObject!]

struct TableSection {
    var title: String!
    var footer: String!
    var rows = [TableRow]()

    init(title: String!, rows: [TableRow]) {
        self.title = title
        self.rows = rows
    }
}

struct TableRow {
    var data = TableData()
    var height: CGFloat?

    init(data: TableData) {
        self.data = data
    }
}