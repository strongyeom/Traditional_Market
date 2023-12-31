//
//  StampViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit
import PhotosUI
import Toast

protocol SavedStamp: AnyObject {
    func savedStamp()
}

final class StampViewController : BaseViewController {
    
    enum EnterStampMethod {
        case toast
        case click
    }
    
    
    
    private let stampView = StampView()
    
    private let realmManager = RealmManager()
    
    var selectedMarket: TraditionalMarketRealm?
    
    var enterStampMethod: EnterStampMethod = .click
    
    weak var delegate: SavedStamp?
    
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
        stampView.memoTextView.resignFirstResponder()
    }
    
    
}


extension StampViewController {

    fileprivate func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBtnClicked))
        navigationItem.title = "기록하기"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "stampColor")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    fileprivate func setStampView() {
        
        guard let selectedMarket else { return }
        stampView.marketName.text = selectedMarket.marketName
        stampView.marketType.text = selectedMarket.marketType
        stampView.memoTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stampImageTapped))
        stampView.stampImage.addGestureRecognizer(tapGesture)
        stampView.cancelCompletion = {
            self.dismiss(animated: true)
        }
        
        stampView.saveCompletion = {
            
            if self.stampView.memoTextView.text == "텍스트를 입력해주세요" && self.stampView.memoTextView.textColor == UIColor.lightGray || self.stampView.memoTextView.text.isEmpty {
                self.showAlert(title: "메모장이 비어있습니다.", btnTitle: "확인", message: "메모장에 기록을 남겨주세요.", style: .default, completionHander: nil)
            } else if self.stampView.memoTextView.text != "텍스트를 입력해주세요" && !self.stampView.memoTextView.text.isEmpty {
                // 해당 시장안에 "저장"버튼 클릭시 메모 추가
                self.realmManager.myFavoriteMarket(market: selectedMarket, text: self.stampView.memoTextView.text)

                switch self.enterStampMethod {
                case .click:
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                case .toast:
                    self.dismiss(animated: true)
                }
              
            }
            
            if self.stampView.stampImage.image != nil {
                let id = self.selectedImageId()
                self.saveImageToDocument(fileName: "myPhoto_\(id).jpg", image: self.stampView.stampImage.image!)
            } else {
                self.stampView.stampImage.image = UIImage(named: "basicStamp2")
            }
            
            NotificationCenter.default.post(name: Notification.Name("SavedStamp"), object: nil)
            
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
        
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photoLibray)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
    }

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
    
    // TextView 소문자만
    func textViewDidChange(_ textView: UITextView) {
        stampView.memoTextView.text = textView.text.lowercased()
    }
}

// MARK: - PHPickerViewControllerDelegate
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


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
