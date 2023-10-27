//
//  DetailConditionView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/25.
//

import UIKit

protocol ApplyBtnAction: AnyObject {
    func cancelBtnClicked()
    func applyBtnClicked()
}

final class DetailConditionView : BaseView {
    
    let bgView = {
       let view = UIView()
        return view
    }()
    
    let detailConditionTitleLabel = {
       let view = UILabel()
        view.text = "오일장 상세조건".localized
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    let detailConditionDescriptionLabel = {
       let view = UILabel()
        view.text = "지도의 현 위치에서 해당 숫자가 포함된 오일장만 표시됩니다.".localized
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 11)
        view.textColor = .lightGray
        return view
    }()
 
    let numberOneBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "1일")
        return view
    }()
    
    let numberTwoBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "2일")
        return view
    }()
    
    let numberThreeBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "3일")
        return view
    }()
    
    let numberFourBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "4일")
        return view
    }()
    
    let numberFiveBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "5일")
        return view
    }()
    
    let numberSixBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "6일")
        return view
    }()
    
    let numberSevenBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "7일")
        return view
    }()
    
    let numberEightBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "8일")
        return view
    }()
    
    let numberNineBtn = {
       let view = UIButton()
        view.detailConditionBtn(day: "9일")
        return view
    }()
    
    let cancelBtn = {
        let view = UIButton()
        view.stampBtnLayout(text: "취소".localized, colorname: "brandColor")
        return view
    }()
    
    let successBtn = {
        let view = UIButton()
        view.stampBtnLayout(text: "적용하기".localized, colorname: "brandColor")
        return view
    }()
    
    
    
    lazy var applyStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelBtn, successBtn])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var firstLineStackView = {
        let stack = UIStackView(arrangedSubviews: [numberOneBtn, numberTwoBtn, numberThreeBtn])
        
        stack.basicSettingStackView(axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillEqually)
        return stack
    }()
    
    lazy var seconLineStackView = {
        let stack = UIStackView(arrangedSubviews: [numberFourBtn, numberFiveBtn, numberSixBtn])
        
        stack.basicSettingStackView(axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillEqually)
        return stack
    }()
    
    lazy var thirdLineStackView = {
        let stack = UIStackView(arrangedSubviews: [numberSevenBtn, numberEightBtn, numberNineBtn])
        
        stack.basicSettingStackView(axis: .horizontal, spacing: 13, alignment: .center, distribution: .fillEqually)
        return stack
    }()
    
    lazy var verticalStackView = {
        let stack = UIStackView(arrangedSubviews: [firstLineStackView, seconLineStackView, thirdLineStackView])
        
        stack.basicSettingStackView(axis: .vertical, spacing: 13, alignment: .fill, distribution: .fillEqually)
        return stack
    }()
    
    var BtnArray = [UIButton]()
    
    weak var delegate: ApplyBtnAction?
    
    var completion: ((String) -> Void)?
    // MARK: - configureView
    override func configureView() {
        self.addSubview(bgView)
        [verticalStackView, applyStackView, detailConditionTitleLabel, detailConditionDescriptionLabel].forEach {
            bgView.addSubview($0)
        }
        
        [numberOneBtn, numberTwoBtn, numberThreeBtn, numberFourBtn, numberFiveBtn, numberSixBtn, numberSevenBtn, numberEightBtn, numberNineBtn].forEach {
            BtnArray.append($0)
            $0.addTarget(self, action: #selector(dayBtnClicked(_:)), for: .touchUpInside)
        }
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClicked(_:)), for: .touchUpInside)
        self.successBtn.addTarget(self, action: #selector(successBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc func cancelBtnClicked(_ sender: UIButton) {
        print(#function)
        delegate?.cancelBtnClicked()
    }
    
    @objc func successBtnClicked(_ sender: UIButton) {
        print(#function)
        delegate?.applyBtnClicked()
    }
    
    @objc func dayBtnClicked(_ sender: UIButton) {
       
        print("버튼이 눌렸다 - DetailConditionView: , \(sender.titleLabel?.text ?? "")")

            for Btn in BtnArray {
                if Btn == sender {
                    // 만약 현재 버튼이 이 함수를 호출한 버튼이라면
                    Btn.isSelected = true
                    Btn.setTitleColor(.black, for: .normal)
                    Btn.backgroundColor = UIColor(named: "clusterCountColor")
                } else {
                    // 이 함수를 호출한 버튼이 아니라면
                    Btn.isSelected = false
                  //  Btn.setTitleColor(.white, for: .normal)
                    Btn.backgroundColor = .clear
                }
            }
        completion?(sender.titleLabel?.text ?? "")
    }
    
    
    // MARK: - setConstraints
    override func setConstraints() {
        bgView.backgroundColor = .secondarySystemBackground
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
        }
        
        
        detailConditionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        detailConditionDescriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(detailConditionTitleLabel.snp.bottom).offset(6)
        }
        
        verticalStackView.snp.makeConstraints { make in
           // make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            
            //
            make.top.equalTo(detailConditionDescriptionLabel.snp.bottom).offset(10)
        }
        
        applyStackView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(13)
            make.horizontalEdges.equalTo(verticalStackView)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.layer.cornerRadius = 16
        self.bgView.layer.cornerCurve = .continuous
        self.bgView.clipsToBounds = true
    }
}
