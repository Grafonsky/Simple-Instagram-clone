import Foundation

enum Constans {
    static let imageModelsKey = "imageModelsKey"
}

struct ImageDataModel: Codable {
    let name: String
    var whoLiked: [String]
    var comments: [String: Date]
}
