//
//  Ext+MapButton.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit

extension UIButton {
    func settingButtonLayer(title: String) {
//        self.layer.cornerRadius = 12
//        self.clipsToBounds = true
//        self.layer.borderColor = UIColor.yellow.cgColor
//        self.layer.borderWidth = 1
//       // self.clipsToBounds = false
      //  self.setTitle(title, for: .normal)
       // self.setTitleColor(.blue, for: .normal)
        
        var config = UIButton.Configuration.filled()
        config.title = title
      //  config.baseForegroundColor = .blue
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        self.configuration = config
    }
}
