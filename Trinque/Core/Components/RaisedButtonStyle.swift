import SwiftUI

/// The app's call to action: a colored button sitting on a darker edge that sinks under the finger.
struct RaisedButtonStyle: ButtonStyle {
    var tint = AppColors.accent
    var edge = AppColors.accentEdge
    var isCompact = false

    @Environment(\.isEnabled) private var isEnabled

    private static let edgeDepth: CGFloat = 5

    func makeBody(configuration: Configuration) -> some View {
        let sink = configuration.isPressed ? Self.edgeDepth - 2 : 0
        configuration.label
            .font(isCompact ? AppType.headline : AppType.button)
            .foregroundStyle(AppColors.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.horizontal, isCompact ? 18 : 24)
            .frame(maxWidth: isCompact ? nil : .infinity, minHeight: isCompact ? 46 : 58)
            .background(shape.fill(tint))
            .background(shape.fill(edge).offset(y: Self.edgeDepth - sink))
            .offset(y: sink)
            .padding(.bottom, Self.edgeDepth)
            .contentShape(shape)
            .opacity(isEnabled ? 1 : 0.45)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: isCompact ? 14 : 29, style: .continuous)
    }
}

extension ButtonStyle where Self == RaisedButtonStyle {
    static var raised: RaisedButtonStyle { RaisedButtonStyle() }
    static var raisedCompact: RaisedButtonStyle { RaisedButtonStyle(isCompact: true) }

    /// The raised button in another pair of colors.
    static func raised(tint: Color, edge: Color) -> RaisedButtonStyle {
        RaisedButtonStyle(tint: tint, edge: edge)
    }
}

/// Presses scale the control down a touch, so a tile never feels dead under the finger.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}

#Preview("Raised buttons") {
    VStack(spacing: 16) {
        Button("Lancer") {}
            .buttonStyle(.raised)
        Button("Vérité") {}
            .buttonStyle(.raised(tint: AppColors.truth, edge: AppColors.truthEdge))
        Button("Réessayer") {}
            .buttonStyle(.raisedCompact)
    }
    .padding()
    .trinquePreview()
}
