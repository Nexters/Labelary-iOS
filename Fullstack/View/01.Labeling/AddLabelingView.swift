//
//  AddLabelingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
// 라벨링 -> 추가

import SwiftUI



struct AddLabelingView: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    
    var body: some View {
        HStack {
            TextField("라벨 검색", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                    
                }
                .padding()
            
        
        }

    }
}

struct AddLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelingView(text: .constant(""))
    }
}
