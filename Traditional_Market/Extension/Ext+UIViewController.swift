//
//  Ext+ShowAlert.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension UIViewController {

    // 도큐먼트 폴더에 이미지를 저장하는 메서드 - 고유값으로 만들어야 됨
    func saveImageToDocument(fileName: String, image: UIImage) {
        // 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        // 저장할 경로설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        print("저장 할 파일 경로 : \(fileURL)")
        // 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file ever error - saveImageToDocument",error)
        }
    }
    
    // 도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageFromDocument(fileName: String) -> UIImage {
        
        // 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return UIImage(named: "basicStamp")! }
        
        // 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 파일명이 유효한지 검증해주는 메서드 ex) "789"이면 시스템 이미지 띄우기
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage(named: "basicStamp")!
        }
    }
    
    // 도큐먼트 폴더에서 이미지 삭제하는 메서드
    func removeImageFromDocument(fileName: String) {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documnentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    
    
    
}
