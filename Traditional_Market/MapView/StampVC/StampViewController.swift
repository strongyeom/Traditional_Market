//
//  StampViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

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
        
        stampView.cancelCompletion = {
            self.dismiss(animated: true)
        }
        
        stampView.saveCompletion = {
            
            if self.stampView.memoTextView.text == "텍스트를 입력해주세요" || self.stampView.memoTextView.text.isEmpty {
                self.showAlert(title: "메모장이 비어있습니다.", message: "메모장에 기록을 남겨주세요.")
            } else if self.stampView.memoTextView.text != "텍스트를 입력해주세요" && !self.stampView.memoTextView.text.isEmpty {
                // 해당 시장안에 "저장"버튼 클릭시 메모 추가
                self.realmManager.myFavoriteMarket(market: selectedMarket, text: self.stampView.memoTextView.text)
                self.dismiss(animated: true)
            }
           
        }
    }
    
    
    // 노티피케이션을 추가하는 메서드
    fileprivate func addKeyboardNotifications() {
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
