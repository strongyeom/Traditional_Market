import UIKit
import SkeletonView

class TitleSupplementaryView: UICollectionReusableView {
    let label = {
        let view = UILabel()
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textAlignment = .left
        view.isSkeletonable = true
        return view
    }()
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        showAnimatedSkeleton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.hideSkeleton()
            self.configure()
        }
        
        
       
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    
    
    func configure() {
        addSubview(label)
        //showAnimatedSkeleton()
        label.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
}
