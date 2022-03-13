//
//  Collection+Extension.swift
//  SearchBookApp
//
//  Created by m.toporkov on 13.03.2022.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {

    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
