//
//  GrayView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import SwiftUI

public struct GrayView: View {
    let opacity: CGFloat
    let callback: (() -> ())?

    public init(
        opacity: CGFloat = 0.9,
        callback: (() -> ())?
    ) {
        self.opacity = opacity
        self.callback = callback
    }
    
    var grayView: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.black)
            .opacity(0.6)
            .onTapGesture {
                callback?()
            }
            .ignoresSafeArea()
    }
    
    public var body: some View {
        grayView
    }
}
