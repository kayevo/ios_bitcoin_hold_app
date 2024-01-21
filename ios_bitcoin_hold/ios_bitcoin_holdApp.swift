import SwiftUI

@main
struct ios_bitcoin_holdApp: App {
    let mockUserId = (secretDictionary?["MOCK_USER_ID"] as? String) ?? ""
    var body: some Scene {
        WindowGroup {     
            // TODO insert main view
            AdsView()
        }
    }
}
