//
//  ViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    let mapView = MapView()
    
    let locationManger = CLLocationManager()
    
    // 권한 상태
    var authorization: CLAuthorizationStatus = .notDetermined

    override func loadView() {
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapView.delegate = self
        locationManger.delegate = self
    }
    
    // 상태가 바뀔때 마다 권한 확인
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            // 위치 서비스를 이용하고 있다면
            if CLLocationManager.locationServicesEnabled() {
                
                if #available(iOS 14.0, *) {
                    self.authorization = self.locationManger.authorizationStatus
                } else {
                    self.authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    print("현재 권한 상태 - \(self.authorization)")
                    self.checkStatuesDeviceLocationAuthorization(status: self.authorization)
                }
            }
        }
    }
    
    
    // 권한 설정에 따른 메서드
    func checkStatuesDeviceLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("아무것도 결정하지 않았다.")
            // p.list 알람 띄우기
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            print("권한 설정 거부함")
        case .denied:
            print("권한 설정 거부함")
        case .authorizedAlways:
            print("항상 권한 허용")
            locationManger.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("한번만 권한 허용")
            locationManger.startUpdatingLocation()
        case .authorized:
            print("권한 허용 됨")
        @unknown default:
            print("어떤것이 추가 될 수 있음")
        }
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("위치를 성공적으로 받아왔을때 : \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 받아오지 못했을때 : \(error.localizedDescription)")
    }
}

extension ViewController: MKMapViewDelegate {
    
}
