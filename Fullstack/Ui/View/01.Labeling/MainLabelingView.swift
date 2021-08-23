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

struct CardViewWithShadow: View {
    var photo: ImageHasher
    var direction: LeftRight?

    var body: some View {
        HStack {
            ZStack {
                ZStack {
                    CardView(photo: photo)
                    Image("shadow_blue")
                        .resizable()
                        .opacity(direction == .right ? 0.7 : 0)
                }
                Image("shadow_red")
                    .resizable()
                    .opacity(direction == .left ? 0.7 : 0)
            }
            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .animation(.default)
        }
    }
}

class NeedToLabelingData: ObservableObject {
    @Published var imageData: [ImageEntity] = []
    @Published var labelData: [LabelEntity] = []
    
    func convertToEntity(hashTypeImage: ImageHasher) -> ImageEntity {
        return hashTypeImage.image
    }

    @Published var isCompleted: Bool = false
}

var neededData = NeedToLabelingData()

struct MainLabelingView: View {
    @State private var isShowingAddLabelingView = false
    @State private var isSwipeToLeft = false
    @ObservedObject var output = Output()
    @State private var deSelectedImage: ImageEntity?
    
    let loadLabelingData = LoadLabelingData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData())) // get unlabeled Images
    
    init() {
        let cancelbag = CancelBag()

        loadLabelingData.get().sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
            output.unlabeledImages.append(contentsOf: data)
            output.setImages(_unlabeledImages: output.unlabeledImages)
        }).store(in: cancelbag)
        
        loadLabelingData.get().sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
            output.unlabeledImages.append(contentsOf: data)
            output.setImages(_unlabeledImages: output.unlabeledImages)
        }).store(in: cancelbag)
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
                        .offset(x: 25)
                    HStack(alignment: .center) {
                        Spacer(minLength: 43)
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
                            content: { photo, direction, _ in
                                CardViewWithShadow(photo: photo, direction: direction)
                            }
                        )
                        
                        .environment(\.cardStackConfiguration, CardStackConfiguration(
                            maxVisibleCards: 1, swipeThreshold: 0.2, cardOffset: 0, cardScale: 1, animation: .default
                        ))
                    }
                    
                    .offset(y: -3)
                }.offset(y: -40)
            }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                    
            HStack {
                // skip button (왼쪽 swipe)
                Button(action: {
                    self.isSwipeToLeft = true
                    self.output.screenshots.removeFirst()
                   
                }, label: {
                    Image("main_skip_btn")
                })
                Spacer(minLength: 35)
                
                // add button (오른쪽 swipe)
                Button(action: {
                    neededData.imageData.append(output.unlabeledImages.first!)
                    self.isShowingAddLabelingView = true
                
                }, label: {
                    Image("main_add_btn")
                })
                    
            }.padding(40)
                .offset(y: 150)
            NavigationLink(
                destination: AddLabelingView(),
                isActive: $isShowingAddLabelingView
            ) {}
        }
    }

    class Output: ObservableObject {
        @Published var screenshots: [ImageHasher] = []
        @Published var unlabeledImages: [ImageEntity] = []
            
        func setImages(_unlabeledImages: [ImageEntity]) {
            screenshots = _unlabeledImages.map {
                ImageHasher(imageEntity: $0)
            }
        }
            
        func hash(into hasher: inout Hasher) {
            hasher.combine(screenshots)
        }
    }
}
