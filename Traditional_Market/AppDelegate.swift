//
//  AppDelegate.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 권한 설정
       UNUserNotificationCenter.current().delegate = self
        // requestAuthorization(options: ) - 알림이 왔을때 어떠한 형식으로 보여주게 할 것인지
        // completionHandler: Bool - 사용자가 권한을 설정 했는지 안했는지
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            print(success, error)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate {
    // willPresent: 포그라운드 상태에서 알림 받을 수 있는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 알림 갯수 제한 : 64개로 제한
        completionHandler([.sound, .badge, .banner, .list])
    }
}
