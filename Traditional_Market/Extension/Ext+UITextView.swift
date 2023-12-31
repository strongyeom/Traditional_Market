//
//  Ext+UITextView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

extension UITextView {
    func stampTextViewLayout() {
        
        self.layer.borderColor = UIColor(named: "stampColor")?.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.text = "텍스트를 입력해주세요"
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 15)
        self.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
 
    
}

