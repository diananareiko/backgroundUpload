import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var backgroundCompletionHandler: (() -> Void)?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DependencyInjectionContainer.shared.register(APIService() as APIServiceProtocol)
        if var apiService = DependencyInjectionContainer.shared.resolve(APIServiceProtocol.self) {
            apiService.backgroundCompletionHandler = backgroundCompletionHandler
            DependencyInjectionContainer.shared.register(UploadImagesService(apiService: apiService) as UploadImagesServiceProtocol)
          }
        return true
    }
    
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundCompletionHandler = completionHandler
    }
}
