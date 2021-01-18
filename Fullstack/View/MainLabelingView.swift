//
//  MainLabelingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
//

import SwiftUI
import CardStack

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
    
    static let mock: [Photo] = [
        Photo(image: UIImage(named: "sc1")!),
        Photo(image: UIImage(named: "sc2")!),
        Photo(image: UIImage(named: "sc3")!),
        Photo(image: UIImage(named: "sc4")!),
        Photo(image: UIImage(named: "1")!),
        Photo(image: UIImage(named: "2")!),
        Photo(image: UIImage(named: "3")!),
        Photo(image: UIImage(named: "4")!),
        Photo(image: UIImage(named: "5")!)
        
    ]
}


struct CardView: View {
    let photo: Photo
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Image(uiImage: self.photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.width)
                    .clipped()
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .padding()
    }
}


struct MainLabelingView: View {
    @State var data: [Photo] = Photo.mock
    var body: some View {
        CardStack(
            direction: LeftRight.direction,
            data: data,
            onSwipe: { card, direction in
                print("Swiped \(direction)")
    
                if direction == .right
                {
                    print("오른쪽 : 라벨 추가")
                }
                
            },
            content: { photo,_,_  in
                CardView(photo: photo) 
            }
        )
        .padding()
        .scaledToFit()
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    

//    if direction == left {
//
//    } else {
//
//    }
    
}

    
struct MainLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            MainLabelingView()
                .tabItem { Image(systemName: "photo.fill")
                Text("라벨링")
                }
        }
       
    }
}
 
