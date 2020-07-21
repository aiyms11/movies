import Foundation
import Alamofire
import SwiftyJSON
class MovieService {
    func getMovies(page: Int, movieType: String, completion: @escaping (Swift.Result<[Movie],Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/\(movieType)?api_key=cdef50713aa8ea4d3acc70f077c1062c#"
        guard let url = URL(string: urlString) else { return }
        let parameters: Parameters = [
            //"api_key": urlParametrs.key,
            "page": page
               ]
        request(url, method: .get, parameters: parameters).validate().responseJSON { responseJSON in
        //validate().responseJSON
            switch responseJSON.result {
            case .success(let value):
                let jsonResult = JSON(value)
                var movies: [Movie] = []
                jsonResult["results"].forEach { (result) in
                    let movie = Movie(id: result.1["id"].intValue, originalTitle: result.1["original_title"].stringValue, posterPath: result.1["poster_path"].stringValue, overview: result.1["overview"].stringValue)
                    movies.append(movie)
                }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

