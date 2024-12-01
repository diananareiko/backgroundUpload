import SwiftUI

class Coordinator: ObservableObject {
    
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    @ViewBuilder
    func build(page: AppPage) -> some View {
        switch page {
        case .createTransferPage:
            CreateTransferView()
        case .filesPage:
            FilesView()
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        default:
            CreateTransferView()
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        default:
            CreateTransferView()
        }
    }
    
    func push(page: AppPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover) {
        self.fullScreenCover = cover
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissCover() {
        fullScreenCover = nil
    }
}
