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
        
        let listVC = ListViewController()
        listVC.tabBarItem.title = "목록"
        listVC.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        let listVCHome = UINavigationController(rootViewController: listVC)
        
        
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem.title = "나의 시장"
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        let profileVCHome = UINavigationController(rootViewController: profileVC)
        
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = UIColor(named: "brandColor")
        self.tabBar.tintColor = UIColor.white // 탭 아이콘의 색상
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.standardAppearance = apperance
        self.tabBar.scrollEdgeAppearance = apperance
        
        setViewControllers([mapVCHome, listVCHome, profileVCHome], animated: false)
    }
}
