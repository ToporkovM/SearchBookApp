//
//  UITableViewCell+Extension.swift
//  SearchBookApp
//
//  Created by m.toporkov on 13.03.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self.self) }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
