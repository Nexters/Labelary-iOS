import CardStack
import SwiftUI
import ToastUI

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
    
    static let mock: [Photo] = [
        Photo(image: UIImage(named: "sc1")!),
        Photo(image: UIImage(named: "sc2")!),
        Photo(image: UIImage(named: "sc3")!),
        Photo(image: UIImage(named: "sc4")!)
    ]
}

struct CardView: View {
    var photo: Photo
    
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .center) {
                Image(uiImage: self.photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 248, height: 535)
            }
            .cornerRadius(1.5)
        }
    }
}

struct MainLabelingView: View {
    @State var data: [Photo] = Photo.mock
    @State private var isShowingAddLabelingView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 30) {
                    Text("스크린샷 라벨링")
                        .offset(y: -50)
                    ZStack {
                        Image("shadow_img")
                            .offset(y: 82)
                        CardStack(
                            direction: LeftRight.direction,
                            data: data,
                            onSwipe: { _, direction in
                       
                                if direction == .right {
                                    print("오른쪽 : 라벨 추가")
                                    self.isShowingAddLabelingView = true
                                }
                                print(data)
                                
                            },
                            content: { photo, _, _ in
                                CardView(photo: photo)
                            }
                        )
                        .scaledToFit()
                        .offset(x: 65)
                    }.offset(y: -140)
                }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                    
                HStack {
                    Button(action: {
                        self.data.removeFirst()
                    }, label: {
                        Image("main_skip_btn")
                    })
                    Spacer(minLength: 35)
                    
                    Button(action: {
                        self.isShowingAddLabelingView = true
                    }, label: {
                        NavigationLink(
                            destination: AddLabelingView(),
                            isActive: $isShowingAddLabelingView
                        ) {
                            Image("main_add_btn")
                        }
                    })
                        
                }.padding(40)
                    .offset(y: 150)
            }
        }
    }
}
    
