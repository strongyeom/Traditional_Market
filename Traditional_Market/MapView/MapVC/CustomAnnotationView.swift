//
//  CustomAnnotationView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import Foundation
import MapKit

class CustomAnnotationView : MKAnnotationView {
    
    let backgroundView = UIView()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .orange
        label.textAlignment = .center
        return label
    }()
    
    var customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var stacView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [customImageView, titleLabel])
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(stacView)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
        
        stacView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    // Annotation도 재사용을 하므로 재사용 전 값을 초기화 시켜서 다른 값이 들어가는 것을 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        titleLabel.text = nil
    }
    
    // 이 메서드는 annotation이 뷰에서 표시되기 전에 호출됩니다.
    // 즉, 뷰에 들어갈 값을 미리 설정할 수 있습니다
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? CustomAnnotation else { return }
        
        titleLabel.text = annotation.title
        
        guard let imageName = annotation.imageName,
              let image = UIImage(named: imageName) else { return }
        
        customImageView.image = image
        
        // 이미지의 크기 및 레이블의 사이즈가 변경될 수도 있으므로 레이아웃을 업데이트 한다.
        setNeedsLayout()
        
        // 참고. drawing life cycle :
        // setNeedsLayout를 통해 다음 런루프에서 레이아웃을 업데이트하도록 예약
        // -> layoutSubviews을 통해 레이아웃 업데이트
        
        // layoutSubviews를 쓰려면 setNeedsLayout도 항상 같이 사용해야 한다고 하네요.
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // MKAnnotationView 크기를 backgroundView 크기 만큼 정해줌.
        bounds.size = CGSize(width: 70, height: 70)
        // 중심점을 기준으로 크기의 절반만큼 이동
        centerOffset = CGPoint(x: 0, y: 35)
    }
    
}
