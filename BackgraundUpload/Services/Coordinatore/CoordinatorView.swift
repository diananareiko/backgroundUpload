import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .createTransferPage)
                .navigationDestination(for: AppPage.self) { page in
                    coordinator.build(page: page)
                }.sheet(item: $coordinator.sheet) { sheet in
                    coordinator.buildSheet(sheet: sheet)
                }.fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.buildCover(cover: fullScreenCover)
                }
        }.environmentObject(coordinator)
    }
}

#Preview {
    CoordinatorView()
}
