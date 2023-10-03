//
//  Ext+UIButton.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

extension UIButton {
    func stampBtnLayout(text: String) {
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "btnColor")
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
}

