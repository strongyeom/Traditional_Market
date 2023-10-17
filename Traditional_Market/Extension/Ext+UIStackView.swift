//
//  Ext+UIStackView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/15.
//

import UIKit

extension UIStackView {
    
    func basicSettingStackView(axis: NSLayoutConstraint.Axis,
                          spacing: CGFloat,
                          alignment: UIStackView.Alignment,
                          distribution: UIStackView.Distribution) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    
    func mypageSetupStackView() {
        self.axis = .vertical
        self.spacing = 5
        self.alignment = .center
        self.distribution = .fillEqually
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
