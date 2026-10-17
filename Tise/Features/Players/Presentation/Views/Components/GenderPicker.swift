import SwiftUI

/// The two pills that pick the sex of the next player.
struct GenderPicker: View {
    @Binding var selection: Gender

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Gender.allCases, id: \.self) { gender in
                GenderPill(gender: gender, isSelected: selection == gender) {
                    selection = gender
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Sexe")
    }
}

/// One sex of the picker, filled with its color when chosen.
private struct GenderPill: View {
    let gender: Gender
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Label(gender.title, systemImage: gender.symbol)
                .font(AppType.headline)
                .foregroundStyle(isSelected ? AppColors.textPrimary : gender.tint)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(isSelected ? gender.tint : .clear, in: .capsule)
                .overlay(Capsule().strokeBorder(gender.tint, lineWidth: 2))
                .contentShape(.capsule)
        }
        .buttonStyle(.pressable)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Gender picker") {
    @Previewable @State var gender = Gender.female
    GenderPicker(selection: $gender)
        .padding()
        .appPreview()
}
