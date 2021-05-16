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
//    @Binding var imageEntity : ImageEntity
    @Environment(\.presentationMode) var presentationMode
    @Binding var screenShot: ImageEntity
    @State var isOnHover: Bool = true
    let requestBookmarkImage = BookmarkImage(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
    let deleteImages = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
    let onChangeBookMark: (Bool) -> Void
    let onDeleteImage: (String) -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                ImageView(img: screenShot)
                    .aspectRatio(contentMode: .fit)
            }
            VStack(spacing: 0) {
                if isOnHover {
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

                if isOnHover {
                    HStack {
                        if screenShot.labels.isEmpty {
                            Text("스크린샷에 추가된 라벨이 없습니다.")
                                .font(Font.B1_MEDIUM)
                                .foregroundColor(Color.PRIMARY_3)
                                .padding(.leading, 16)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(screenShot.labels.indices, id: \.self) { i in
                                        let label = screenShot.labels[i]
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
                    ZStack {}.frame(width: .infinity, height: 0.5).background(Color.PRIMARY_2)
                    HStack {
                        Image("ico_delete_active").onTapGesture {
                            delete()
                        }
                        Spacer()
                        if screenShot.isBookmark {
                            Image("ico_heart_active").onTapGesture {
                                changeBookMark()
                            }
                        } else {
                            Image("ico_heart").onTapGesture {
                                changeBookMark()
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
            self.isOnHover = !isOnHover
        }.navigationBarHidden(true)
    }

    private func changeBookMark() {
        requestBookmarkImage.get(param: BookmarkImage.Param(isActive: !screenShot.isBookmark, image: screenShot))
            .sink(receiveCompletion: { complete in print("\(complete)") }, receiveValue: { data in
                print("\(data)")
                screenShot = data
                onChangeBookMark(data.isBookmark)
            })
    }

    private func delete() {
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [screenShot.source], options: nil).firstObject!
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray) // 배열에 담아서 NSArray로 바꿔줘야 합니다. 정확히는 NSFastEnumerator를 상속받은 클래스면 됩니다.
        }, completionHandler: { isDone, error in
            print("idDone \(isDone) : \(Thread.current.isMainThread)")
            if isDone {
                DispatchQueue.main.async {
                    onDeleteImage(screenShot.id)
                    self.presentationMode.wrappedValue.dismiss()
                }
//                deleteImages.get(param: [screenShot])
//                    .sink(receiveCompletion: { _ in
//                        onDeleteImage(screenShot.id)
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, receiveValue: { _ in })
            } else {
                print(error.debugDescription)
            }
        })
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
