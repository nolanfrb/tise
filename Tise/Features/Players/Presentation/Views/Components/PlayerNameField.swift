import SwiftUI

/// The outlined capsule where a name is typed, with its round add button.
struct PlayerNameField: View {
    @Binding var name: String
    let isFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField(text: $name, prompt: Text("Ajoute un joueur").foregroundStyle(AppColors.textTertiary)) {
                Text("Prénom")
            }
            .font(AppType.headline)
            .foregroundStyle(AppColors.textPrimary)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .submitLabel(.done)
            .focused(isFocused)
            .onSubmit(onSubmit)
            Button("Ajouter le joueur", systemImage: "plus", action: onSubmit)
                .labelStyle(.iconOnly)
                .font(AppType.symbol(20))
                .foregroundStyle(AppColors.background)
                .frame(width: 44, height: 44)
                .background(AppColors.textPrimary, in: .circle)
                .opacity(Player.isValidName(name) ? 1 : 0.35)
                .disabled(!Player.isValidName(name))
                .contentShape(.circle)
        }
        .padding(.leading, 22)
        .padding(.trailing, 8)
        .frame(minHeight: 60)
        .background(AppColors.cardBottom, in: .capsule)
        .overlay(Capsule().strokeBorder(AppColors.textPrimary.opacity(0.9), lineWidth: 2))
        .background(Capsule().fill(AppColors.textPrimary.opacity(0.25)).offset(y: 4))
    }
}

#Preview("Name field") {
    @Previewable @State var name = "Léa"
    @Previewable @FocusState var isFocused: Bool
    PlayerNameField(name: $name, isFocused: $isFocused) {}
        .padding()
        .appPreview()
}
