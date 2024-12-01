import Foundation

struct AppConfiguration {
    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "IMGBB_API_KEY") as? String, !key.isEmpty else {
            fatalError("⚠️ API Key is missing. Please register at https://imgbb.com and add your key to the Info.plist file.")
        }
        return key
    }()
}
