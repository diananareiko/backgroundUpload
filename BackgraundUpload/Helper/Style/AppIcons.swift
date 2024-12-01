import Foundation
import SwiftUI

enum AppIcons {
    case chevronRight
    case plus
    case delete
    case upload
    case close
    case cross
    case chevronLeft
    
    var image: Image {
        switch self {
        case .chevronRight:
            return Image(systemName: "chevron.right")
        case .plus:
            return Image(systemName: "plus")
        case .delete:
            return Image(systemName: "trash")
        case .upload:
            return Image(systemName: "arrow.up.to.line")
        case .close:
            return Image(systemName: "xmark.circle.fill")
        case .cross:
            return Image(systemName: "xmark")
        case .chevronLeft:
            return Image(systemName: "chevron.left")
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .chevronRight:
            return "Chevron Right"
        case .chevronLeft:
            return "Chevron Left"
        case .plus:
            return "Add"
        case .delete:
            return "Delete"
        case .upload:
            return "Upload"
        case .close:
            return "Close"
        case .cross:
            return "Close"
        }
    }
}
