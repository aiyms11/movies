import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

class MovieCell: UITableViewCell {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ pictureView, titleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        return stackView
    }()
    private let pictureView = UIImageView()
    private let titleLabel = UILabel()
    private var viewModel = ImageService()
    private var indicatorView = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
        indicatorView.hidesWhenStopped = true
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.originalTitle
        viewModel.posterImage(movie.posterPath) { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.pictureView.image = image
                self?.indicatorView.stopAnimating()
            case .failure(let error):
                print(error)
                self?.indicatorView.stopAnimating()
            }
        }
        
    }
    
    func configure(isLoading: Bool) {
        if isLoading {
            indicatorView.startAnimating()
        }
    }
    
    private func layoutUI() {
        pictureView.contentMode = .scaleAspectFill
        pictureView.layer.masksToBounds = true
        pictureView.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(2)
        }
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    
}

