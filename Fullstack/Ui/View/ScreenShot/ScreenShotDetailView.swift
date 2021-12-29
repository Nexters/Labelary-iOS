//
//  ScreenShotDetailView.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import AlertToast
import Foundation
import Photos
import RealmSwift
import SwiftUI

struct ScreenShotDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewmodel: ViewModel
    let onChangeBookMark: (ImageEntity) -> Void
    let onDeleteImage: (String) -> Void
    @State private var showToastOn = false
    @State private var showToastOff = false
    @State private var showNextView = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack(alignment: .center) {
                ImageView(viewModel: viewmodel.imageViewModel)
                    .aspectRatio(contentMode: .fit)
            }
            VStack(spacing: 0) {
                if viewmodel.isOnHover {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("ico_back")
                        }
                        Spacer()
                        Text(viewmodel.createdAt) // 날짜
                            .font(Font.B1_MEDIUM)
                            .foregroundColor(Color.PRIMARY_1)
                        Spacer()
                    }.padding(EdgeInsets(top: 68, leading: 20, bottom: 16, trailing: 20))
                        .background(Color(hex: "B3000000"))
                        .edgesIgnoringSafeArea(.top)
                }

                Spacer()

                if viewmodel.isOnHover {
                    HStack {
                        if viewmodel.getlabel(image: viewmodel.imageViewModel.image).isEmpty {
                            Text("스크린샷에 추가된 라벨이 없습니다.")
                                .font(Font.B1_MEDIUM)
                                .foregroundColor(Color.PRIMARY_3)
                                .padding(.leading, 16)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewmodel.getlabel(image: viewmodel.imageViewModel.image).indices, id: \.self) { i in
                                        // let label = viewmodel.imageViewModel.image.labels[i]
                                        let label = viewmodel.getlabel(image: viewmodel.imageViewModel.image)[i]
                                        Text(label.name)
                                            .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                            .font(Font.B1_REGULAR)
                                            .foregroundColor(label.color.text)
                                            .background(label.color.deactive)
                                            .cornerRadius(3)
                                    }
                                }
                            }
                        }

                        Spacer()

                        NavigationLink(
                            destination: ScreenShotDetailLabelView(image: [viewmodel.imageViewModel.image]),
                            isActive: $showNextView
                        ) {
                            Text("추가")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color.KEY_ACTIVE)
                                .padding(.leading, 6)
                        }

                    }.padding(EdgeInsets(top: 22, leading: 20, bottom: 22, trailing: 20))
                        .background(Color(hex: "B3000000"))
                    //      ZStack {}.frame(width: .infinity, height: 0.5).background(Color.PRIMARY_2)
                    HStack {
                        Image("ico_delete_active").onTapGesture {
                            viewmodel.delete()
                        }
                        Spacer()
                        if viewmodel.imageViewModel.image.isBookmark {
                            Image("ico_heart_active").onTapGesture {
                                viewmodel.changeBookMark()
                                showToastOff.toggle()
                            }
                        } else {
                            Image("ico_heart").onTapGesture {
                                viewmodel.changeBookMark()
                                showToastOn.toggle()
                            }
                        }
                        Spacer()

                        Button(action: {
                            let imageToShare = viewmodel.imageViewModel.uiImage
                            let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
                            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)

                        }) {
                            Image("ico_share")
                        }
                    }.padding(EdgeInsets(top: 22, leading: 34, bottom: 56, trailing: 34))
                        .background(Color(hex: "B3000000"))
                        .edgesIgnoringSafeArea(.bottom)
                }
            }.edgesIgnoringSafeArea([.top, .bottom])

        }.toast(isPresenting: $showToastOn, duration: 0.6) {
            AlertToast(displayMode: .alert, type: .image("ico_heart-1", .DEPTH_1), subTitle: "즐겨찾기에서\n추가되었습니다.", style: .style(backgroundColor: Color(hex: "B3000000"), subTitleColor: Color.PRIMARY_1, subTitleFont: Font.B1_REGULAR))
        }
        .toast(isPresenting: $showToastOff, duration: 0.6) {
            AlertToast(displayMode: .alert, type: .image("ico_heart-1", .DEPTH_1), subTitle: "즐겨찾기에서\n삭제되었습니다.", style: .style(backgroundColor: Color(hex: "B3000000"), subTitleColor: Color.PRIMARY_1, subTitleFont: Font.B1_REGULAR))
        }
        .toast(isPresenting: viewmodel.$showDeleteToast, duration: 0.7) {
            AlertToast(displayMode: .alert, type: .regular, subTitle: "스크린샷이 삭제되었습니다.")
        }
        .onTapGesture {
            viewmodel.isOnHover = !viewmodel.isOnHover
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    class ViewModel: ObservableObject {
        let realm: Realm = try! Realm()

        @Published var imageViewModel: ImageViewModel
        @Published var isOnHover: Bool = true
        @Published var LabelImageData: [LabelImageEntity] = []
        @Published var createdAt: String = ""
        @Published var labelImageDict: [LabelEntity: [LabelImageEntity]] = [:]
        @State var showDeleteToast = false
        @Environment(\.presentationMode) var presentationMode

        let onChangeBookmark: (ImageEntity) -> Void

        let requestBookmarkImage = BookmarkImage(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let deleteImages = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let cancelbag = CancelBag()
        let dateFormatter = DateFormatter()

        let searchLabelByImage = SearchLabelByImage(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        init(imageViewModel: ImageViewModel, onChangeBookmark: @escaping (ImageEntity) -> Void) {
            self.imageViewModel = imageViewModel
            self.onChangeBookmark = onChangeBookmark
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            createdAt = dateFormatter.string(from: imageViewModel.image.createdAt ?? Date())
        }

        func getlabel(image: ImageEntity) -> [LabelEntity] {
            var labels: [LabelEntity] = []
            searchLabelByImage.get(param: image).sink(receiveCompletion: { _ in }, receiveValue: {
                data in
                labels.append(contentsOf: data.first?.labels ?? [])
            }).store(in: cancelbag)
            return labels
        }

        func changeBookMark() {
            let isBookMark = !imageViewModel.image.isBookmark
            requestBookmarkImage.get(param: BookmarkImage.Param(isActive: isBookMark, image: imageViewModel.image))
                .sink(receiveCompletion: { complete in print("\(complete)") }, receiveValue: { data in
                    DispatchQueue.main.async {
                        print(data)
                        self.imageViewModel = ImageViewModel(image: data)
                        self.onChangeBookmark(data)
                    }
                }).store(in: cancelbag)
        }

        func delete() {
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageViewModel.image.source], options: nil).firstObject!

            PHPhotoLibrary.shared().performChanges({ [self] in
                print("imageentity id:", imageViewModel.image.id)
                PHAssetChangeRequest.deleteAssets([asset] as NSArray) // 배열에 담아서 NSArray로 바꿔줘야 합니다. 정확히는 NSFastEnumerator를 상속받은 클래스면 됩니다.
            }, completionHandler: { isDone, error in
                print(isDone ? "success+++" : error.debugDescription)
                if isDone {
                    self.showDeleteToast = true
                    print("삭제 완료!")
                }
            })

//            deleteImages.get(param: [imageViewModel.image]).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
//                .store(in: cancelbag)
        }
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
