//
//  Model.swift
//  UICollectionViewControllerWithAutoLayout
//
//  Created by Артём Кармазь on 6/2/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

struct Item {
    var color: UIColor
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}


