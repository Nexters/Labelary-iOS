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
                        .frame(width: UIScreen.screenWidth * 0.71, height: UIScreen.screenHeight * 0.6)
                    
                    Image("shadow_blue")
                        .resizable()
                        .frame(width: UIScreen.screenWidth * 0.72, height: UIScreen.screenHeight * 0.62)
                        .opacity(direction == .right ? 0.7 : 0)
                }

                Image("shadow_red")
                    .resizable()
                    .frame(width: UIScreen.screenWidth * 0.72, height: UIScreen.screenHeight * 0.62)
                    .opacity(direction == .left ? 0.7 : 0)
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
    @State var reloadToken = UUID()
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                HStack {
                    Text("스크린샷 라벨링".localized())
                        .font(Font.H3_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                    
                    Text("+\(self.viewModel.screenshots.count)")
                        .padding(4)
                        .foregroundColor(Color.PRIMARY_1)
                        .font(Font.B2_MEDIUM)
                        .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(2.0)
                }.offset(y: -30)
                
                ZStack {
                    Image("shadow")
                        .resizable()
                        .frame(width: UIScreen.screenWidth * 0.71, height: UIScreen.screenHeight * 0.6)
                        .offset(x: 25)
                    HStack(alignment: .center) {
                        CardStack(
                            direction: LeftRight.direction,
                            data: self.viewModel.screenshots,
                            onSwipe: { data, direction in
                                
                                if direction == .right {
                                    needToLabelingData.imageData.append(data.image)
//                                    posthog?.capture("PostHog-SwipeRight")
                                    avo?.swipeRight()
                                    self.isShowingAddLabelingView = true
                                }
                                
                                if direction == .left {
//                                    posthog?.capture("PostHog-SwipeLeft")
                                    avo?.swipeLeft()
                                    needToLabelingData.imageData.removeAll() // 여기서 초기화해주기
                                }

                            },
                            content: { photo, direction, _ in
                               
                                CardViewWithShadow(photo: photo, direction: direction)
                                    .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.58)
                            }
                        )
                        .environment(\.cardStackConfiguration, .init(maxVisibleCards: 1, animation: .linear(duration: 0)))
                        .id(reloadToken)
                        .overlay(
                            HStack {
                                // Left Button
                                Button(action: {
//                                    posthog?.capture("SkipButton")
                                    needToLabelingData.imageData.removeAll() // 여기서 초기화해주기
                                    self.reloadToken = UUID()
                                    self.viewModel.screenshots = self.viewModel.screenshots.shuffled()
                                    
                                }, label: {
                                    Image("main_skip_btn")
                                        .resizable()
                                        .frame(width: 115, height: 70, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                        
                                })
                                Spacer(minLength: 150)
                            
                                // Right Button
                                Button(action: {
//                                    posthog?.capture("Pressed Select Button")
                                    needToLabelingData.imageData.append(viewModel.screenshots.first!.image)
                                    self.isShowingAddLabelingView = true
                                   
                                }, label: {
                                    Image("main_add_btn")
                                        .resizable()
                                        .frame(width: 115, height: 70, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                })
                            }
                            .offset(y: 210)
                        )
                    }.onAppear(perform: {
                        self.reloadToken = UUID()
                    })
                }.padding(.top, 40)
                    .padding(.leading, 63)
                    .padding(.trailing, 64)
                    .padding(.bottom, 57)
            }
            NavigationLink(
                destination: AddLabelingView(),
                isActive: $isShowingAddLabelingView
            ) {}
        }.onAppear(perform: {
//            posthog?.capture("[01.Labeling]MainLabelingView")
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
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] status in
                DispatchQueue.main.async {
                    [unowned self] in
                    showUI(for: status)
                }
            }
        }
        
        func passBtnAction() {
            screenshots.removeFirst()
        }
        
        // 권한 허용 묻고 허용되면 스크린샷들 불러오기
        func showUI(for status: PHAuthorizationStatus) {
            switch status {
            case .authorized:
                refresh()
            case .denied:
                print("Album : denied")
                break
            case .limited:
                print("Album : limited authorization granted ")
                break
            default:
                break
            }
        }
        
        func refresh() {
            loadLabelingData.get().sink(receiveCompletion: { _ in },
                                        receiveValue: { [self] data in
                self.unlabeledImages = data
                                           // self.unlabeledImages.append(contentsOf: data)
                                            self.setImages(_unlabeledImages: unlabeledImages)
                                            unlabeledImagesViewModel = unlabeledImages.map {
                                                UnlabeledImageViewModel(image: $0)
                                            }
                                        
                                        }).store(in: cancelbag)
        }
        
        func setImages(_unlabeledImages: [ImageEntity]) {
            screenshots = _unlabeledImages.map {
                ImageHasher(imageEntity: $0)
            }
        }
        
    }
}
