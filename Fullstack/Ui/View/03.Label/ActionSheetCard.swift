//
//  ActionSheetCard.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import Combine
import SwiftUI

struct ActionSheetCard: View {
    @State var offset = UIScreen.main.bounds.height
    @Binding var isShowing: Bool
    
    let items: [ActionSheetCardItem]
    let heightToDisappear = UIScreen.main.bounds.height
    let cellHeight: CGFloat = 87
    let backgroundColor: Color
    
    public init(
        isShowing: Binding<Bool>,
        items: [ActionSheetCardItem],
        backgroundColor: Color = Color.DEPTH_2
    ) {
        _isShowing = isShowing
        self.items = items
        self.backgroundColor = backgroundColor
    }
    
    func hide() {
        offset = heightToDisappear
        isShowing = false
    }
    
    var itemsView: some View {
        VStack {
            ForEach(0 ..< items.count) { index in
                if index > 0 {
                    Divider()
                }
                
                items[index]
                    .frame(height: cellHeight)
            }
        }
    }
    
    var interactiveGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    offset = value.location.y
                }
            }
            .onEnded { value in
                let diff = abs(offset - value.location.y)
                if diff > 100 {
                    hide()
                }
                else {
                    offset = 0
                }
            }
    }
    
    var outOfFocusArea: some View {
        Group {
            if isShowing {
                GrayView {
                    self.isShowing = false
                }
            }
        }
    }
    
    var sheetView: some View {
        VStack {
            itemsView
        }
        .frame(width: 335, height: 175)
        .background(backgroundColor)
        .cornerRadius(20)
        .offset(y: 200)
        .gesture(interactiveGesture)
        .onTapGesture {
            hide()
        }
    }
    
    var bodyContent: some View {
        ZStack {
            outOfFocusArea
            sheetView
        }
    }
    
    var body: some View {
        Group {
            if isShowing {
                bodyContent
            }
        }
        .animation(.default)
        .onReceive(Just(isShowing), perform: { isShowing in
            offset = isShowing ? 0 : heightToDisappear
        })
    }
}
