//
//  StampViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

class StampViewController : BaseViewController {
    
    let stampView = StampView()
    
    override func loadView() {
        self.view = stampView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBtnClicked))
        navigationItem.title = "스탬프 추가하기"
    }
    
    @objc func leftBtnClicked() {
        dismiss(animated: true)
    }
    
    override func setConstraints() {
        
    }
}
