//
//  Ext+ShowAlert.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completionHander: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 일단 삭제 메서드만 만들어놓고 범위 들어왔을때는 토스트나 추가 메서드 작성하자
        
        let ok = UIAlertAction(title: "삭제", style: .destructive, handler: completionHander)
        
        
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
        print("\(fileName).jpg")
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

extension UIViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        view.frame.origin.y -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}
