//
//  SimpleTableViewDataSource.swift
//  BI-Reporting
//
//  Created by Daniel Garbień on 26/04/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit

// U must be a UITableViewCell or it's subclass
class SimpleTableViewDataSource<T, U: AnyObject>: NSObject, UITableViewDataSource {
    
    typealias ConfigureCellBlock = (item: T, cell: U, indexPath: NSIndexPath) -> Void
    typealias RegisterCellBlock = (tableView: UITableView, cellIdentifier: String) -> Void
    
    init(items: [T], registerCell: RegisterCellBlock, cellIdentifier: String = String(U), configureCell: ConfigureCellBlock) {
        self.items = items
        self.configureCell = configureCell
        self.cellIdentifier = cellIdentifier
        self.registerCell = registerCell
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> T {
        return items[indexPath.row]
    }
    
    private let items: [T]
    private let configureCell: ConfigureCellBlock
    private let cellIdentifier: String
    private var registerCell: RegisterCellBlock?
    
    // MARK: - UITableViewDataSource
    
    final func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    final func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        registerCell?(tableView: tableView, cellIdentifier: cellIdentifier)
        registerCell = nil
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! U
        configureCell(item: itemAtIndexPath(indexPath), cell: cell, indexPath: indexPath)
        return cell as! UITableViewCell
    }
}


enum CellType {
    case Class
    case Nib(UINib)
}

extension SimpleTableViewDataSource {
    
    convenience init(items: [T], cellType: CellType = .Class, configureCell: ConfigureCellBlock) {
        let registerCell: RegisterCellBlock = {
            switch cellType {
            case .Class:
                return { tableView, cellIdentifier -> Void in
                    tableView.registerClass(U.self, forCellReuseIdentifier: cellIdentifier)
                }
            case .Nib(let nib):
                return { tableView, cellIdentifier -> Void in
                    tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
                }
            }
        }()
        self.init(items: items,
                  registerCell: registerCell,
                  configureCell: configureCell)
    }
}
