import SwiftUI

@main
struct ios_bitcoin_holdApp: App {
    var body: some Scene {
        WindowGroup {     
            // TODO insert sign in view
            PortfolioView( userId: 
                (secretDictionary?["MOCK_USER_ID"] as? String) ?? ""
            )
        }
    }
}
