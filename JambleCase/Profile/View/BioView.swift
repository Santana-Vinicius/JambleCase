import SwiftUI

struct BioView: View {
    let text: String
    @State private var isExpanded = false
    @State private var isTruncated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.system(size: 14))
                .lineLimit(isExpanded ? nil : 2)
                .background(
                    ViewThatFits(in: .vertical) {
                        Text(text)
                            .font(.system(size: 14))
                            .hidden()
                            .onAppear { isTruncated = false }

                        Color.clear
                            .onAppear { isTruncated = true }
                    }
                )

            if isTruncated || isExpanded {
                Button(isExpanded ? "Show less" : "Read more") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
