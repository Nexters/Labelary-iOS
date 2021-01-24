//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

// 즐겨찾기 목록 데이타
struct Screenshot: Identifiable {
    var id: Int
    let imageName: String //uuid ?? 앨범에서 꺼내올때
}

struct ThumnailView: View {
    let screenshot: Screenshot
    var body: some View {
        Image("\(screenshot.imageName)")
            .resizable()
            .cornerRadius(10)
            .frame(width: 80, height: 160)
    }
}

struct SearchView: View {
    
    let screenshots: [Screenshot] = [
        Screenshot(id: 0, imageName: "sc0"),
        Screenshot(id: 1, imageName: "sc1"),
        Screenshot(id: 2, imageName: "sc2"),
        Screenshot(id: 3, imageName: "sc3")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                
            SearchBar(text: .constant(""))
            Spacer(minLength: 15)
            HStack(spacing: 200) {
            Text("최근 순 사진")
            Button(action: {
                    // 모두보기 화면으로 이동
                
            }, label: {
                    Text("모두보기")})
            }
                
            ScrollView {
                HStack {
                    ForEach(screenshots, id: \.id) {
                        screenshot in ThumnailView(screenshot: screenshot)
                    }
                }
            }
                HStack(spacing: 200) {
                Text("즐겨찾는 사진")
                Button(action: {
                        // 모두보기 화면으로 이동
                    
                }, label: {
                        Text("모두보기")})
                }
                
                ScrollView {
                    HStack {
                        ForEach(screenshots, id: \.id) {
                            screenshot in ThumnailView(screenshot: screenshot)
                        }
                    }
                }
            
            .padding(20)
            .navigationBarTitle(Text("탐색"))
        }
        }
        
     
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
