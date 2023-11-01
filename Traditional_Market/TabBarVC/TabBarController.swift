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
        

        
        let mapVC = MapViewController()
        mapVC.tabBarItem.title = "지도"
        mapVC.tabBarItem.image = UIImage(systemName: "map")
        let mapVCHome = UINavigationController(rootViewController: mapVC)
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        let homeVCHome = UINavigationController(rootViewController: homeVC)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem.title = "나의 시장"
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        let profileVCHome = UINavigationController(rootViewController: profileVC)
        
        
        self.tabBar.tintColor = UIColor.white // 탭 아이콘의 색상
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.backgroundColor = UIColor(named: "brandColor") // 탭바의 배경 색상
        setViewControllers([mapVCHome, homeVCHome, profileVCHome], animated: false)
    }
}
