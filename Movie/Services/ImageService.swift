import Foundation
import Alamofire

class ImageService {
    func posterImage(_ imagePath: String, completion: @escaping (Swift.Result<UIImage,Error>) -> Void){
        request("https://image.tmdb.org/t/p/w500\(imagePath)").responseData { response in
            var picture = UIImage()
            switch response.result {
            case .success(let imageData):
                picture = UIImage(data: imageData)!
                completion(.success(picture))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
