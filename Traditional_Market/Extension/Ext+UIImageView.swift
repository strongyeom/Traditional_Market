//
//  Ext+UIImageView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/15.
//

import UIKit

extension UIImageView {
    func basicSettingImageView() {
        self.contentMode = .scaleToFill
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
    }
}
