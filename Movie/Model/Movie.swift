import Foundation

struct Movie: Decodable {
    let id: Int
    let originalTitle: String
    let posterPath: String
    let overview: String
}
