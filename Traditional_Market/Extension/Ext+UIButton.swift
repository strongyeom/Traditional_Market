//
//  Ext+UIButton.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

extension UIButton {
    
    func mapSetupButtonLayer(title: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        self.configuration = config
    }
    
    func stampBtnLayout(text: String) {
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "btnColor")
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    func mypageSetupButton() {
        var config = UIButton.Configuration.plain()
        config.title = "시장 컬렉션"
        config.baseForegroundColor = UIColor(named: "blackAndWhiteColor")
        config.titleAlignment = .center
        config.buttonSize = .medium
        config.image = UIImage(systemName: "chevron.forward")
        config.imagePadding = 7
        config.imagePlacement = .trailing
        config.baseForegroundColor = UIColor(named: "blackAndWhiteColor")
        self.configuration = config
    }
    
    func configureImagebtn(title: String) {
        self.setTitle(title, for: .normal)
        self.tintColor = .systemBlue
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}

