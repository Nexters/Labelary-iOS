//
//  SplashView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/20.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                MainLabelingView()
            } else {
                Image("onboarding")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            }
        }.onAppear(perform:
            animateSplash
        )
    }
    
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isActive.toggle()
               // self.isActive = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
