import AlertToast
import CardStack
import PhotosUI
import RealmSwift
import SwiftUI
 
struct CardView: View {
    var photo: ImageHasher
    
    var body: some View {
        HStack(alignment: .center) {
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
                        .frame(width: UIScreen.screenWidth * 0.71, height: UIScreen.screenHeight * 0.581)
                        .opacity(direction == .right ? 0.6 : 0)
                }

                Image("shadow_red")
                    .resizable()
                    .frame(width: UIScreen.screenWidth * 0.71, height: UIScreen.screenHeight * 0.581)
                    .opacity(direction == .left ? 0.6 : 0)
            }

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
}

var needToLabelingData = NeedToLabelingData()

class PresentToast: ObservableObject {
    @Published var presentToast = false
}

var presentToast = PresentToast()

struct MainLabelingView: View {
    @State private var isShowingAddLabelingView = false
    @State private var isSwipeToLeft = false
    @State var reloadToken = UUID()
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
        
            VStack(alignment: .center) {
                HStack {
                    Text("스크린샷 라벨링")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(Color.PRIMARY_1)
                    
                    Text("+\(self.viewModel.screenshots.count)")
                        .foregroundColor(Color.PRIMARY_1)
                        .font(.system(size: 14))
                        .frame(height: 21, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(2.0)
                }
                Spacer(minLength: 40)
                ZStack {
                    Image("shadow")
                        .resizable()
                        .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.58)
                        .offset(x: 25)
                    HStack(alignment: .center) {
                        CardStack(
                            direction: LeftRight.direction,
                            data: self.viewModel.screenshots,
                            onSwipe: { _, direction in
                                
                                if direction == .right {
                                    needToLabelingData.imageData.append(viewModel.screenshots.first!.image)
                                    self.isShowingAddLabelingView = true
                                }

                            },
                            content: { photo, direction, _ in
                               
                                CardViewWithShadow(photo: photo, direction: direction)
                                    .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.58)
                            }
                        )
                        .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.58)
                        .environment(\.cardStackConfiguration, CardStackConfiguration(
                            maxVisibleCards: 1, swipeThreshold: 0.2, cardOffset: 0, cardScale: 1
                        ))
                        .id(reloadToken)
                        .overlay(
                            HStack {
                                // Left Button
                                Button(action: {
                                    self.reloadToken = UUID()
                                    self.isSwipeToLeft = true
                                    self.viewModel.screenshots = self.viewModel.screenshots.shuffled()
                                    print("shuffle")
                                }, label: {
                                    Image("main_skip_btn")
                                })
                                Spacer(minLength: 150)
                            
                                // Right Button
                                Button(action: {
                                    needToLabelingData.imageData.append(viewModel.screenshots.first!.image)
                                    self.isShowingAddLabelingView = true
                            
                                }, label: {
                                    Image("main_add_btn")
                                })
                                
                            }.padding(40)
                                .offset(y: 150)
                        )
                    }
                    
                    .offset(y: -3)
                }
                .offset(y: -40)
            }
            
            NavigationLink(
                destination: AddLabelingView(),
                isActive: $isShowingAddLabelingView
            ) {}
        }.onAppear(perform: {
            needToLabelingData.imageData.removeAll() // 여기서 초기화해주기
        })
    }

    class ViewModel: ObservableObject {
        @Published var screenshots: [ImageHasher] = []
        @Published var unlabeledImages: [ImageEntity] = []
        @Published var unlabeledImagesViewModel: [UnlabeledImageViewModel] = []
        @Published var isAuthorized = PHPhotoLibrary.authorizationStatus()
        
        let loadLabelingData = LoadLabelingData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        
        let cancelbag = CancelBag()
        
        init() {
            loadLabelingData.get().sink(receiveCompletion: { _ in },
                                        receiveValue: { [self] data in
                                            self.unlabeledImages.append(contentsOf: data)
                                            self.setImages(_unlabeledImages: unlabeledImages)
                                            unlabeledImagesViewModel = unlabeledImages.map {
                                                UnlabeledImageViewModel(image: $0)
                                            }
                                        
                                        }).store(in: cancelbag)
        }
        
        func passBtnAction() {
            screenshots.removeFirst()
        }
        
//        func showUI() {
//            if PHPhotoLibrary.authorizationStatus() == .authorized {
//                refresh()
//                print("authorized")
//            }
//        }
        
        func setImages(_unlabeledImages: [ImageEntity]) {
            screenshots = _unlabeledImages.map {
                ImageHasher(imageEntity: $0)
            }
        }
        
        // 왼쪽 버튼 눌렀을 때
        /*
         func hash(into hasher: inout Hasher) {
             hasher.combine(screenshots)
         }
         */
    }
}
