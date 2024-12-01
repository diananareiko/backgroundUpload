import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var completionHandler: (() -> Void)?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DependencyInjectionContainer.shared.register(UploadImagesService(apiService: APIService()) as UploadImagesServiceProtocol)
        return true
    }
    
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
}
