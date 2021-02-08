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
                    Image("tabbar_add")
                }
            SearchView()
                .tabItem {
                    Image("tabbar_home")
                }
            AlbumView()
                .tabItem {
                    Image("tabbar_album")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
