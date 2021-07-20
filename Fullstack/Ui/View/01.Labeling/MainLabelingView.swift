import CardStack
import SwiftUI
import ToastUI

struct CardView: View {
    var photo: ImageHasher
    
    var body: some View {
        VStack(alignment: .center) {
            CardStackView(img: self.photo.image)
        }
    }
}

class NeedToLabelingData: ObservableObject {
    @Published var imageData: [ImageEntity] = []
    @Published var labelData: [LabelEntity] = []
    
    func convertToEntity(hashTypeImage: ImageHasher) -> ImageEntity {
        return hashTypeImage.image
    }

    @Published var isCompleted: Bool?
}

var neededData = NeedToLabelingData()

struct MainLabelingView: View {
    @State private var isShowingAddLabelingView = false
    @State private var isSwipe = false
    @ObservedObject var output = Output()
    @State private var deSelectedImage: ImageEntity?
    
    let loadAllImageData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
    let loadLabelingData = LoadLabelingData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData())) // get unlabeled Images
    init() {
        let cancelbag = CancelBag()
        loadAllImageData.get()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] data in
                    output.setImages(recentScreenshots: data.recentlyImages)
                    output.labeledImages = data.recentlyImages
                }
            ).store(in: cancelbag)
    }
    
    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                HStack {
                    Text("스크린샷 라벨링")
                        .font(.system(size: 18, weight: .heavy))
                    Text("+\(output.screenshots.count)")
                        .font(.system(size: 14))
                        .frame(width: 38, height: 21, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(2.0)
                }.offset(y: -30)

                ZStack(alignment: .center) {
                    Image("shadow")
                        .resizable()
                        .frame(width: 248, height: 535, alignment: .center)
                    HStack {
                        Spacer(minLength: 63)
                        CardStack(
                            direction: LeftRight.direction,
                            data: self.output.screenshots,
                            onSwipe: { card, direction in
                                
                                if direction == .right {
                                    // shadow ui 넣기
                                    neededData.imageData.append(neededData.convertToEntity(hashTypeImage: card))
                                    self.isShowingAddLabelingView = true
                                    
                                }

                            },
                            content: { photo, _, _ in
                                CardView(photo: photo)
                            }
                        )
                        .environment(\.cardStackConfiguration, CardStackConfiguration(
                            maxVisibleCards: 1, swipeThreshold: 0.2, cardOffset: 0, cardScale: 1, animation: .linear
                        ))
                    }
                }
            }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                    
            HStack {
                // skip button (왼쪽 swipe)
                Button(action: {
                    self.isSwipe = true
                    output.labeledImages.removeFirst()
                }, label: {
                    Image("main_skip_btn")
                })
                Spacer(minLength: 35)
                
                // add button (오른쪽 swipe)
                Button(action: {
                    neededData.imageData.append(output.labeledImages.first!)
                    output.labeledImages.removeFirst()
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
        @Published var labeledImages: [ImageEntity] = []
            
        func setImages(recentScreenshots: [ImageEntity]) {
            screenshots = recentScreenshots.map {
                ImageHasher(imageEntity: $0)
            }
        }
            
        func hash(into hasher: inout Hasher) {
            hasher.combine(screenshots)
        }
    }
}
    
