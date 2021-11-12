//
//  ScreenShotDetailView.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import Foundation
import Photos
import SwiftUI

struct ScreenShotDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewmodel: ViewModel
    let onChangeBookMark: (ImageEntity) -> Void
    let onDeleteImage: (String) -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                ImageView(viewModel: viewmodel.imageViewModel)
                    .aspectRatio(contentMode: .fit)
            }
            VStack(spacing: 0) {
                if viewmodel.isOnHover {
                    HStack {
                        Image("ico_back")
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                        Text("2019년 1월 24일")
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
                        Text("추가")
                            .font(Font.B2_MEDIUM)
                            .foregroundColor(Color.KEY_ACTIVE)
                            .padding(.leading, 6)
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
                            }
                        } else {
                            Image("ico_heart").onTapGesture {
                                viewmodel.changeBookMark()
                            }
                        }
                        Spacer()
                        Image("ico_share")
                    }.padding(EdgeInsets(top: 22, leading: 34, bottom: 56, trailing: 34))
                        .background(Color(hex: "B3000000"))
                        .edgesIgnoringSafeArea(.bottom)
                }
            }.edgesIgnoringSafeArea([.top, .bottom])

        }.onTapGesture {
            viewmodel.isOnHover = !viewmodel.isOnHover
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }

    class ViewModel: ObservableObject {
        @Published var imageViewModel: ImageViewModel
        @Published var isOnHover: Bool = true

        @Published var LabelImageData: [LabelImageEntity] = []

        @Published var labelImageDict: [LabelEntity: [LabelImageEntity]] = [:]

        let onChangeBookmark: (ImageEntity) -> Void

        let requestBookmarkImage = BookmarkImage(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let deleteImages = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let cancelbag = CancelBag()

        let searchLabelByImage = SearchLabelByImage(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        init(imageViewModel: ImageViewModel, onChangeBookmark: @escaping (ImageEntity) -> Void) {
            self.imageViewModel = imageViewModel
            self.onChangeBookmark = onChangeBookmark
        }

        func getlabel(image: ImageEntity) -> [LabelEntity] {
            var labels: [LabelEntity] = []
            searchLabelByImage.get(param: image).sink(receiveCompletion: { _ in }, receiveValue: {
                data in
                labels.append(contentsOf: data)
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
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray) // 배열에 담아서 NSArray로 바꿔줘야 합니다. 정확히는 NSFastEnumerator를 상속받은 클래스면 됩니다.
            }, completionHandler: { isDone, error in
                print("idDone \(isDone) : \(Thread.current.isMainThread)")
                if isDone {
                    self.deleteImages.get(param: [self.imageViewModel.image])
                        .sink(receiveCompletion: { _ in
//                            onDeleteImage(viewmodel.screenShot.id)
//                            self.presentationMode.wrappedValue.dismiss()
                        }, receiveValue: { _ in })
                        .store(in: self.cancelbag)
                } else {
                    print(error.debugDescription)
                }
            })
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
