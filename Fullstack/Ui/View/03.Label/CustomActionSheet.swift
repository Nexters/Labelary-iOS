import SwiftUI

public struct ActionSheetCardItem: View {
    let id = UUID()
    let label: String
    let labelFont: Font
    let foregroundColor: Color
    let foregroundInactiveColor: Color
    let callback: (() -> ())?

    public init(label: String,
                labelFont: Font = Font.headline,
                foregroundColor: Color = Color.white,
                foregroundInactiveColor: Color = Color.white,
                callback: (() -> ())? = nil)
    {
        self.label = label
        self.labelFont = labelFont
        self.foregroundColor = foregroundColor
        self.foregroundInactiveColor = foregroundInactiveColor
        self.callback = callback
    }

    var buttonView: some View {
        HStack(alignment: .center) {
            Text(label)
                .font(labelFont)
        }
    }

    public var body: some View {
        Group {
            if let callback = callback {
                Button(action: {
                    callback()
                }) {
                    buttonView
                        .foregroundColor(foregroundColor)
                }
            } else {
                buttonView.foregroundColor(foregroundInactiveColor)
            }
        }
    }
}
