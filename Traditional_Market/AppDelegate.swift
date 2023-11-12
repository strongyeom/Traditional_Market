//
//  AppDelegate.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // 원격 알림 등록 : 푸시든 로컬이든 알람 허용해야 그 이후가 가능!!
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        //FireBaseMessaging
       // Messaging.messaging().delegate = self
        
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
  //   willPresent: 포그라운드 상태에서 알림 받을 수 있는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 알림 갯수 제한 : 64개로 제한
        completionHandler([.sound, .badge, .banner, .list])
    }
    
    // 디바이스 토큰
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device - token : \(token)")
    }
    
}

/*
 
 👉 Firebase Push Notifications 이용시 FCM 토큰 가져오는 메서드
 extension AppDelegate : MessagingDelegate {
     // FireBase 맵핑된 토큰에 관련된 정보를 받아 올 수 있음
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
       print("Firebase registration token: \(String(describing: fcmToken))")

       let dataDict: [String: String] = ["token": fcmToken ?? ""]
       NotificationCenter.default.post(
         name: Notification.Name("FCMToken"),
         object: nil,
         userInfo: dataDict
       )
     }
 }
 */
