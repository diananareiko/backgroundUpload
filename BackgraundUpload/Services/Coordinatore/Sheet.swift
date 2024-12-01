import Foundation

enum Sheet: String, Identifiable {

    var id: String {
        self.rawValue
    }
    
    case nextSheet
}
