import CardStack
import SwiftUI
import ToastUI


struct CardView: View {
    var photo: ImageHasher
    
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .center) {
                ImageView(img: self.photo.image)
                    .frame(width: 248, height: 535)
            }
            .cornerRadius(1.5)
        }
    }
}

struct MainLabelingView: View {
    @State private var isShowingAddLabelingView = false
    @State private var isSwipe = false // 왼쪽으로 swipe하는 경우만 있음
    @ObservedObject var output = Output()
    
    let loadScreenshots = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

    init() {
        let cancelbag = CancelBag()
        loadScreenshots.get()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] data in
                    output.setImages(recentScreenshots: data.recentlyImages)
                }
                  
            ).store(in: cancelbag)
    }
    
    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 30) {
                HStack {
                    Text("스크린샷 라벨링")
                    Text("+\(output.screenshots.count)")
                        .font(.system(size: 14))
                        .frame(width: 38, height: 21, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(2.0)
                        
                }.offset(y: -50)
          
                ZStack {
                    Image("shadow_img")
                        .offset(y: 82)
                    CardStack(
                        direction: LeftRight.direction,
                        data: self.output.screenshots,
                        onSwipe: { _, direction in
                            
                            if direction == .right {
                                // shadow ui 넣기
                                ZStack {
                                    Image("shadow_blue")
                                }
                                self.isShowingAddLabelingView = true
                            }

                            if direction == .left {
                                
                                self.output.screenshots.removeFirst()
                            }
                                
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
                // skip button
                Button(action: {
                    self.isSwipe = true
                    self.output.screenshots.removeFirst()
                   
                }, label: {
                    Image("main_skip_btn")
                })
                Spacer(minLength: 35)
                
                // add button
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
    
    class Output: ObservableObject {
        @Published var screenshots: [ImageHasher] = []
        
        func setImages(recentScreenshots: [ImageEntity]) {
            self.screenshots = recentScreenshots.map {
                ImageHasher(imageEntity: $0)
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.screenshots)
        }
    }
}
    
