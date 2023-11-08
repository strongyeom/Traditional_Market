import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    let label = {
        let view = UILabel()
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textAlignment = .left
        view.backgroundColor = .yellow
        return view
    }()
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
