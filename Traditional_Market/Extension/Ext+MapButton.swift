//
//  Ext+MapButton.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit

extension UIButton {
    func settingButtonLayer(title: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        self.configuration = config
    }
}
