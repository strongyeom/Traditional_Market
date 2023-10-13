//
//  StampViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit
import PhotosUI

final class StampViewController : BaseViewController {
    
    private let stampView = StampView()
    
    private let realmManager = RealmManager()
    
    var selectedMarket: TraditionalMarketRealm?
    
    override func loadView() {
        self.view = stampView
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        setNavigationBar()
        setStampView()
        addKeyboardNotifications()
    }
    

    

    @objc func leftBtnClicked() {
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self.view.endEditing(true)
        stampView.memoTextView.resignFirstResponder()
    }
    
    
}


extension StampViewController {
    
    fileprivate func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBtnClicked))
        navigationItem.title = "스탬프 추가하기"
        
        
    }
    
    fileprivate func setStampView() {
        
        guard let selectedMarket else { return }
        stampView.marketTitle.text = selectedMarket.marketName
        stampView.memoTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stampImageTapped))
        stampView.stampImage.addGestureRecognizer(tapGesture)
        stampView.cancelCompletion = {
            self.dismiss(animated: true)
        }
        
        stampView.saveCompletion = {
            
            if self.stampView.memoTextView.text == "텍스트를 입력해주세요" && self.stampView.memoTextView.textColor == UIColor.lightGray || self.stampView.memoTextView.text.isEmpty {
                self.showAlert(title: "메모장이 비어있습니다.", message: "메모장에 기록을 남겨주세요.", completionHander: nil)
            } else if self.stampView.memoTextView.text != "텍스트를 입력해주세요" && !self.stampView.memoTextView.text.isEmpty {
                // 해당 시장안에 "저장"버튼 클릭시 메모 추가
                self.realmManager.myFavoriteMarket(market: selectedMarket, text: self.stampView.memoTextView.text)
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

            }
            
            if self.stampView.stampImage.image != nil {
                let id = self.selectedImageId()
                
                self.saveImageToDocument(fileName: "myPhoto_\(id).jpg", image: self.stampView.stampImage.image!)
            } else {
                self.stampView.stampImage.image = UIImage(named: "basicStamp")
            }
        }
    }
 
    func selectedImageId() -> String {
        let favorite = realmManager.allOfFavoriteRealmCount().first!
        return "\(favorite._id)"
    }
    
    func selectedMarketConvertToFavoriteMarket(marktet: TraditionalMarketRealm) -> FavoriteTable {
        
        let favoriteMarket = FavoriteTable(marketName: marktet.marketName, marketType: marktet.marketType, loadNameAddress: marktet.loadNameAddress, address: marktet.address, marketOpenCycle: marktet.marketOpenCycle, latitude: marktet.latitude, longitude: marktet.longitude, popularProducts: marktet.popularProducts ?? "", phoneNumber: marktet.phoneNumber, memo: stampView.memoTextView.text!, date: Date())
        return favoriteMarket
    }
    
    
    @objc func stampImageTapped() {
        print("스탬프 사진 클릭 됌 -- ")
     
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
            let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
                guard let self else { return }
                let camera = UIImagePickerController()
                camera.sourceType = .camera
                camera.allowsEditing = true
                camera.cameraCaptureMode = .photo
                camera.delegate = self
                self.present(camera, animated: true)
            }
        
            let photoLibray = UIAlertAction(title: "갤러리", style: .default) { [weak self] _ in
                guard let self else { return }
                var config = PHPickerConfiguration()
                config.selectionLimit = 1
                config.filter = .images
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                self.present(picker, animated: true)
            }
        
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photoLibray)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
    }
    
    
//    // 노티피케이션을 추가하는 메서드
//    fileprivate func addKeyboardNotifications() {
//        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
//        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//
//    @objc func keyboardWillShow(_ sender: Notification) {
//        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
//        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardHeight = keyboardFrame.cgRectValue.height
//        view.frame.origin.y -= keyboardHeight
//    }
//
//    @objc func keyboardWillHide(_ sender: Notification) {
//        if view.frame.origin.y != 0 {
//            view.frame.origin.y = 0
//        }
//    }
}


// MARK: - TextView PlaceHolder
extension StampViewController : UITextViewDelegate {
    // 텍스트 칼라가 회색이면 -> nil, textColor -> black
    func textViewDidBeginEditing(_ textView: UITextView) {
        if stampView.memoTextView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    // 텍스트가 비어있으면 placeHolder, 회색으로 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        if stampView.memoTextView.text.isEmpty {
            stampView.memoTextView.text = "텍스트를 입력해주세요"
            stampView.memoTextView.textColor = .lightGray
        }
    }
}

extension StampViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.stampView.stampImage.image = image as? UIImage // 5
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}

extension StampViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            stampView.stampImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
