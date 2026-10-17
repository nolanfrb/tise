import SwiftUI

/// App entry point; everything the app shows is composed in [RootView], where a preview can render it.
@main
struct TrinqueApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(container: .live)
        }
    }
}
