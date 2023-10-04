//
//  ProfileViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/03.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    
    enum SectionLayoutKind: Int, CaseIterable {
        case grid
        case list
        
        var columnCount: Int {
            switch self {
            case .grid:
                return 6
            case .list:
                return 3
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func setConstraints() {
        
    }
}
