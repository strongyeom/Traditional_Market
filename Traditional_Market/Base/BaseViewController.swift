//
//  BaseViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/28.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        
    }
}
