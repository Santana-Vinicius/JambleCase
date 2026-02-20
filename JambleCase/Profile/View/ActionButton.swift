import SwiftUI

struct ActionButton: View {
    var dto: ActionButtonDTO
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            contentLabel
                .foregroundStyle(dto.foregroundColor)
                .frame(height: 40)
                .background(background)
        }
    }

    @ViewBuilder
    private var contentLabel: some View {
        switch dto.content {
        case .text(let title):
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 16)
        case .icon(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .frame(width: 40)
        }
    }

    @ViewBuilder
    private var background: some View {
        switch dto.style {
        case .filled(let color):
            Capsule().fill(color)
        case .outlined(let color):
            Capsule().stroke(color, lineWidth: 1)
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        ActionButton(
            dto: .init(
                content: .text("Invite · R$15"),
                style: .filled(Color(red: 126/255, green: 83/255, blue: 248/255)),
                foregroundColor: .white
            )
        ) {}

        ActionButton(
            dto: .init(
                content: .text("Refer Sellers · R$500"),
                style: .filled(.black),
                foregroundColor: .white
            )
        ) {}

        ActionButton(
            dto: .init(
                content: .icon("icon-share"),
                style: .filled(.black),
                foregroundColor: .black
            )
        ) {}

        ActionButton(
            dto: .init(
                content: .icon("icon-heart-red"),
                style: .outlined(.black),
                foregroundColor: .black
            )
        ) {}
    }
    .padding()
}
