import SwiftUI

/// The state of one asynchronous load: loading, data, or error, never two at once.
enum ViewState<Value> {
    case loading
    case loaded(Value)
    case failed(Error)

    var value: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

/// Renders a [ViewState] with its three branches; the failure branch is shared by every screen.
struct ViewStateView<Value, Loading: View, Content: View>: View {
    let state: ViewState<Value>
    let onRetry: () -> Void
    @ViewBuilder let loading: () -> Loading
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .loading:
            loading()
        case .loaded(let value):
            content(value)
        case .failed:
            AppErrorView(onRetry: onRetry)
        }
    }
}

/// The shared failure message, with a way to try again.
struct AppErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(AppType.symbol(34))
                .foregroundStyle(AppColors.textSecondary)
                .accessibilityHidden(true)
            Text("Les cartes n'ont pas chargé")
                .font(AppType.title)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            Button("Réessayer", action: onRetry)
                .buttonStyle(.raisedCompact)
                .padding(.top, 6)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Error") {
    AppErrorView(onRetry: {})
        .trinquePreview()
}
