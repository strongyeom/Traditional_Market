//
//  TabBarController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/03.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MapViewController()
        
        mainVC.tabBarItem.title = "지도".localized
        mainVC.tabBarItem.image = UIImage(systemName: "map")
        let mainVCHome = UINavigationController(rootViewController: mainVC)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem.title = "나의 시장".localized
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        let profileVCHome = UINavigationController(rootViewController: profileVC)
        
        
        self.tabBar.tintColor = UIColor.white // 탭 아이콘의 색상
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.backgroundColor = UIColor(named: "brandColor") // 탭바의 배경 색상
        setViewControllers([mainVCHome, profileVCHome], animated: false)
    }
}
