import SwiftUI

enum AppColors {

    case hex3768EC
    case hexF8F8F8
    case hex1C1C1C
    case hex757575
    
    var color: Color {
        switch self {
        case .hex3768EC:
            return Color(hex: "#3768EC")
        case .hexF8F8F8:
            return Color(hex: "#F8F8F8")
        case .hex1C1C1C:
            return Color(hex: "#1C1C1C")
        case .hex757575:
            return Color(hex: "#757575")
        }
    }
}
