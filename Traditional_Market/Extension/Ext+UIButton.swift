//
//  Ext+UIButton.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

extension UIButton {
    func stampBtnLayout(text: String) {
//        var config = UIButton.Configuration.filled()
//        config.title = text
//        config.baseBackgroundColor = UIColor(named: "btnColor")
//        config.baseForegroundColor = .white
//       // config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
//        config.titleAlignment = .center
//        self.configuration = config
//
        
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "btnColor")
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
}

