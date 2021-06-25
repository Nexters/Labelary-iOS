import CardStack
import SwiftUI
import ToastUI

// struct Photo: Identifiable {
//    let id = UUID()
//    let image: UIImage
//
//    static let mock: [Photo] = [
//        Photo(image: UIImage(named: "sc0")!),
//        Photo(image: UIImage(named: "sc1")!),
//        Photo(image: UIImage(named: "sc2")!),
//        Photo(image: UIImage(named: "sc3")!),
//        Photo(image: UIImage(named: "sc4")!),
//        Photo(image: UIImage(named: "sc5")!),
//        Photo(image: UIImage(named: "sc6")!)
//    ]
// }

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
    @State private var screenshotCounter = 0
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
                Text("스크린샷 라벨링")
                    .offset(y: -50)
                Text("+\(screenshotCounter)")
                ZStack {
                    Image("shadow_img")
                        .offset(y: 82)
                    CardStack(
                        direction: LeftRight.direction,
                        data: output.screenshots,
                        onSwipe: { _, direction in
                       
                            if direction == .right {
                                print("오른쪽 : 라벨 추가")
                                ZStack {
                                    Image("shadow_blue")
                                }
                                self.isShowingAddLabelingView = true
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
                Button(action: {
                    self.output.screenshots.removeFirst()
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
    
