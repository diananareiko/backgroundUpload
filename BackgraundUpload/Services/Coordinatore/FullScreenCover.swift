import Foundation

enum FullScreenCover: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case nextFullScreenCover
}
