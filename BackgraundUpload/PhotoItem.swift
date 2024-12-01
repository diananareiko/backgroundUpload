import Foundation
import SwiftData

@Model
class PhotoItem {
    @Attribute(.unique) var id: UUID
    var imageData: Data?

    init(imageData: Data? = nil) {
        self.id = UUID()
        self.imageData = imageData
    }
}
