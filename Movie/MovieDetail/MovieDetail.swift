import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class MovieDetail: UIViewController {
    
    private var movie: Movie
    private var posterImage = UIImageView()
    private var titleLabel = UILabel()
    private var overview = UILabel()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, posterImage, overview])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        return stackView
    }()
    private var viewModel = ImageService()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addDetail()
        viewModel.posterImage(movie.posterPath) { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.posterImage.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addDetail() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        posterImage.contentMode = .scaleAspectFill
        titleLabel.text = movie.originalTitle
        titleLabel.font = titleLabel.font.withSize(22)
        titleLabel.textAlignment = .center
        overview.text = movie.overview
        overview.numberOfLines = 6
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
//        posterImage.snp.makeConstraints { (make) in
//            make.right.left.equalTo(view.safeAreaLayoutGuide)
//            make.top.equalTo(titleLabel.snp.bottom).offset(5)
//        }
//        overview.snp.makeConstraints { (make) in
//            make.right.left.equalTo(view.safeAreaLayoutGuide)
//            make.top.equalTo(posterImage.snp.bottom).offset(5)
//        }
    }
}



