//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색

import SwiftUI

struct SearchLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        SearchBar(text: .constant(""))
     
    }
}

struct SearchLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLabelView()
    }
}
