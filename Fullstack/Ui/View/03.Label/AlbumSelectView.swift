//
//  AlbumSelectView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/28.
//

import SwiftUI
// 스크린샷 선택
struct AlbumSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) { Image("ico_cancel") }
                },
                trailing: HStack {
                    // 라벨 수정하기 -> 스크린샷 라벨 변경 화면으로 이동
                    NavigationLink(destination: AlbumEditLabelView()) {
                        Image("ico_label_edit")
                    }
              
                    // 이미지 삭제하기
                    Button(action: {}) { Image("ico_delete_inactive") }
                })
    }
    
    class ViewModel: ObservableObject {
        let deleteImage = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
    }
}
