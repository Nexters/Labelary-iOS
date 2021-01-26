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
                    Image(systemName: "list.dash")
                    Text("라벨링")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("탐색")
                }
            AlbumView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("앨범")
                }
                
            
            
        }
        
       
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
