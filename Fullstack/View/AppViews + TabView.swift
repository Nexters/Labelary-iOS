//
//  AppView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        
        TabView {
            MainLabelingView()
                .tabItem {
                    Text("라벨링")
                    
            
                }
            
            
        }
        
       
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
