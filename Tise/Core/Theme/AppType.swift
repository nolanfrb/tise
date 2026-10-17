import SwiftUI

/// The rounded type ladder, the only place a font is chosen; every step follows Dynamic Type.
enum AppType {
    static var prompt: Font { .system(.largeTitle, design: .rounded, weight: .heavy) }
    static var title: Font { .system(.title, design: .rounded, weight: .heavy) }
    static var button: Font { .system(.title2, design: .rounded, weight: .heavy) }
    static var headline: Font { .system(.title3, design: .rounded, weight: .bold) }
    static var body: Font { .system(.body, design: .rounded, weight: .medium) }
    static var caption: Font { .system(.subheadline, design: .rounded, weight: .medium) }
    static var tag: Font { .system(.footnote, design: .rounded, weight: .bold) }

    /// A fixed size for decorative glyphs, which illustrate rather than read.
    static func symbol(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black)
    }
}
