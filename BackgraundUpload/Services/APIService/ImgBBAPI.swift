import Foundation

enum ImgBBAPI {

    case uploadImage
}

// MARK: - TargetType

extension ImgBBAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.imgbb.com/1")!
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "/upload"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .uploadImage:
            return [
                URLQueryItem(name: "expiration", value: "600"),
                URLQueryItem(name: "key", value: AppConfiguration.apiKey)
            ]
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "multipart/form-data"]
    }
}
