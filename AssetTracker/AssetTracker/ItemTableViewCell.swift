//
//  ItemTableViewCell.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 23/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static let defaultIndicatorColor = UIColor.blackColor()

    @IBOutlet weak var titleLabel: UILabel!
    var indicatorColor: UIColor = defaultIndicatorColor {
        didSet {
            boxLabel.textColor = indicatorColor
        }
    }
    var liveTappedBlock: (() -> Void)?
    
    @IBOutlet private weak var boxLabel: UILabel!
    
    override func prepareForReuse() {
        liveTappedBlock = nil
        indicatorColor = ItemTableViewCell.defaultIndicatorColor
    }
}

private extension ItemTableViewCell {
    
    @IBAction func liveTapped() {
        liveTappedBlock?()
    }
}
