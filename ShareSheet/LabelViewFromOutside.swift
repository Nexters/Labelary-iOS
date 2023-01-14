//
//  LabelViewFromOutside.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/15.
//

import Combine
import MobileCoreServices
import SwiftUI
import UIKit
import Realm
import RealmSwift

class ShareExtensionViewObservable: ObservableObject {
    @Published var dismiss: Bool = false
}

struct LabelViewFromOutside: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var keyword: String = ""
    @State private var numberOfMyLables: Int = 0
    @State var selectedLabels: [LabelEntity] = []
    @State var showAddLabelView: Bool = false
    
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var sharedImage: model
    @ObservedObject var shareExtension = ShareExtensionViewObservable()

    let cancelBag = CancelBag()
    let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))

    init(sharedImage: model) {
        self.sharedImage = sharedImage
        // 여기서 image 를 imageEntity로 만들어주는 ? 것이 필요한뎅..
//        loadLabelingSelectData.get().sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
//            self.viewModel.labels = data
//            print(data)
//        }).store(in: cancelBag)
    }

    @State var showToast = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.DEPTH_3.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer(minLength: 70)
                            HStack {
                                Spacer()
                                Image(uiImage: sharedImage.imageData ?? UIImage())
                                    .resizable()
                                    .frame(width: 60, height: 131, alignment: .leading)
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            HStack {
                                Spacer(minLength: 20)
                                ShareSheetSearchBarView(text: $keyword).font(Font.system(size: 16)).foregroundColor(Color.primary) // search bar
                                Spacer(minLength: 20)
                            }

                            Spacer(minLength: 40)
                            if self.keyword.isEmpty {
                                HStack {
                                    Text("내 라벨".localized()).font(Font.system(size: 14)).foregroundColor(Color.PRIMARY_2)
                                    Text(" \(self.viewModel.labels.count)").foregroundColor(Color.KEY_ACTIVE)
                                }.padding(.leading, 20)
                            } else {
                                if self.viewModel.labels.filter { $0.name.contains(keyword) }.count > 0 {
                                    HStack {
                                        Text("검색 결과".localized()).font(Font.system(size: 14)).foregroundColor(Color.PRIMARY_2)
                                        Text("\(self.viewModel.labels.filter { $0.name.contains(keyword) }.count)").foregroundColor(Color.KEY_ACTIVE)
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        Text("검색결과가 없습니다 ".localized())
                                            .font(Font.system(size: 14)).foregroundColor(Color.secondary)
                                            .padding(.leading, 20)
                                        Spacer(minLength: 10)

                                        HStack {
                                            Text("\(keyword)").font(Font.system(size: 16)).foregroundColor(Color.secondary).offset(x: 8)
                                            NavigationLink(destination: AddLabelView(), isActive: $showAddLabelView) {
                                                Text("생성".localized())
                                                    .onTapGesture {
                                                        self.showAddLabelView = true
                                                    }

                                            }.foregroundColor(Color.KEY)
                                                .font(Font.system(size: 14))
                                                .padding(8)
                                        }
                                        .background(Color.DEPTH_3)
                                        .cornerRadius(2)
                                        .border(Color.PRIMARY_4)
                                        .offset(x: 20)
                                    }
                                }
                            }
                            FlexibleView(data: self.viewModel.labels.filter { keyword.isEmpty ? true : $0.name.contains(keyword) }, spacing: 8, alignment: HorizontalAlignment.leading) {
                                label in Button(action: {
                                    selectedLabels.insert(label, at: 0)

                                }) {
                                    Text(verbatim: label.name)
                                        .padding(8)
                                        .background(giveLabelBackgroundColor(color: self.viewModel.colorSetToString(color: label.color)))
                                        .foregroundColor(giveTextForegroundColor(color: self.viewModel.colorSetToString(color: label.color)))
                                }
                            }.padding([.leading], 20)
                        }
                        Spacer(minLength: 20)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("추가한 라벨".localized()).foregroundColor(Color.PRIMARY_2)
                                .font(Font.B2_MEDIUM)
                            Text("\(selectedLabels.count)").foregroundColor(Color.KEY_ACTIVE)
                        }.padding([.leading, .top], 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedLabels, id: \.self) { filter in
                                    Badge(name: filter.name, color: giveLabelBackgroundColor(color: self.viewModel.colorSetToString(color: filter.color)), textColor: giveTextForegroundColor(color: self.viewModel.colorSetToString(color: filter.color)), type: .removable {
                                        withAnimation {
                                            if let firstIndex = selectedLabels.firstIndex(of: filter) {
                                                selectedLabels.remove(at: firstIndex)
                                            }
                                        }

                                    })
                                        .transition(.opacity)
                                }
                            }
                        }.padding(20)

                    }.frame(width: UIScreen.main.bounds.width, height: 101)
                        .background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                        .opacity(selectedLabels.count > 0 ? 1 : 0)
                }
                .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        self.shareExtension.dismiss = true
                    }, label: {
                        Image("btn_cancel")
                    }).padding(.trailing, 76)
                    
                    Text("스크린샷 라벨 추가".localized())
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(.trailing, 24)
                },
                    trailing: Button(action: {
                        
                    viewModel.requestLabeling.get(param: RequestLabeling.Param(labels: selectedLabels, images: viewModel.images))
                        self.showToast = true
                        
                    }, label: {
                        Text("완료".localized()).font(Font.system(size: 16))
                            .foregroundColor(Color.KEY_ACTIVE)
                    }))
            }
        }
        .overlay(overlayView: customToast(show: $showToast), show: $showToast)
    }

    class ViewModel: ObservableObject {
        
        var config = Realm.Configuration()
        
        @Published var labels: [LabelEntity] = []
        @Published var images: [ImageEntity] = []
        let cancelBag = CancelBag()
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let loadLabelData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        
        init() {
            loadLabelData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: { data in
                self.labels = data
            }).store(in: cancelBag)
        }
        
        func shareRealm() {
            print(#function)
            let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Fullstack")?.appendingPathComponent("default.realm")
            let sharedConfig = Realm.Configuration(fileURL: directory)
            if let bundleURL = Bundle.main.url(forResource: "bundle", withExtension: "realm") {
                try! FileManager.default.copyItem(at: bundleURL, to: sharedConfig.fileURL!)
                print(sharedConfig.fileURL!)
            } else {
                print(sharedConfig.fileURL!)
                print("file exist")
            }
            
            let realm = try! Realm(configuration: sharedConfig)
            let labels = realm.objects(LabelRealmModel.self) // labelRealmModel -> LabelEntity로 묶어주어야 함 
            
            
        }
        
        
        
        
        func colorSetToString(color: ColorSet) -> String {
            switch color {
            case .YELLOW:
                return "Yellow"
            case .RED:
                return "Red"
            case .VIOLET:
                return "Violet"
            case .BLUE:
                return "Blue"
            case .GREEN:
                return "Green"
            case .ORANGE:
                return "Orange"
            case .PINK:
                return "Pink"
            case .CONBALT_BLUE:
                return "Cobalt_Blue"
            case .PEACOCK_GREEN:
                return "Peacock_Green"
            case .GRAY:
                return "Gray"
            }
        }
    }
}
