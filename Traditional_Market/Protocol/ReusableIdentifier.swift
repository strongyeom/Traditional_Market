//
//  ReusableIdentifier.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension UICollectionReusableView: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
