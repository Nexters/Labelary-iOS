//
//  SettingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/12.
//

import MessageUI
import RealmSwift
import SwiftUI
import UIKit

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showMailView = false
    @State private var showAlert = false
    @State private var mailData = ComposeMailData(subject: "Report", receivers: ["mjwoo001@gmail.com"], message: " write message...", attachments: [AttachmentData(data: "text".data(using: .utf8)!, mimeType: "text/plain", fileName: "text.txt")])
    @State private var showDetail = false
    let onFinished: () -> Void
    let realm = try! Realm()

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.top)
            Color.DEPTH_5.edgesIgnoringSafeArea(.bottom)
            VStack {
                Button(action: {

                    guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1581267873?action=write-review")
                            else { fatalError("Expected a valid URL") }
                        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
//                    posthog?.capture("[04.Settings] WriteReviewOnAppStore", properties: ["label_cnt":realm.objects(LabelRealmModel.self).count])
                }, label: {
                    Text("앱스토어에 리뷰쓰기".localized())
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {
                    guard let urlShare = URL(string: "https://apps.apple.com/kr/app/%EB%A0%88%EC%9D%B4%EB%B8%94%EB%9F%AC%EB%A6%AC/id1581267873?l=en") else { return }
                    let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//                    posthog?.capture("[04.Settings] RecommendLabelary", properties: ["label_cnt":realm.objects(LabelRealmModel.self).count])
                }, label: {
                    Text("친구에게 추천하기".localized())
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.bottom, 20)
                    .padding(.top, -9)

                Button(action: {
                    let url = URL(string: "https://www.notion.so/bf4b20126ab64757856abfcb9db9c66d")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }

                }, label: {
                    Text("이용방법 보기".localized())
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {
                    self.showDetail = true
                }) {
                    Text("빠른 라벨링 설정하기".localized())
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)

                }.frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.top, -9)

                NavigationLink(destination: FastLabelingView(onFinished: onFinished),
                               isActive: $showDetail) {}

                Button(action: {
                    showMailView.toggle()
//                    posthog?.capture("[04.Settings] View Feedback Page", properties: ["user":UIDevice.current.identifierForVendor!.uuidString])
                }, label: {
                    Text("피드백 보내기".localized())
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1).padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.bottom, 20)
                    .padding(.top, -9)
                    .disabled(!MailView.canSendMail)
                    .sheet(isPresented: $showMailView) {
                        MailView(data: $mailData) { result in
                            print(result)
                        }
                    }

                Button(action: {
                    // label 초기화
                    self.showAlert = true
                }, label: {
                    VStack(alignment: .leading) {
                        Text("라벨 초기화하기".localized())
                            .foregroundColor(Color.LABEL_RED_ACTIVE)
                            .font(Font.B1_MEDIUM)
                            .padding(.bottom, 0.5)
                        Text("라벨 내역이 초기화되며, 스크린샷은 삭제되지 않습니다.".localized())
                            .foregroundColor(Color.PRIMARY_2)
                            .font(Font.B2_REGULAR)
                    }.padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 10)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                Spacer()
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("라벨을 초기화하시겠어요?".localized()), message: Text("라벨 엘범과 라벨링 내역이 삭제되며\n 스크린샷은 삭제되지 않습니다".localized()), primaryButton: .cancel(Text("취소".localized())), secondaryButton: .destructive(Text("초기화".localized()), action: {
                    
                    avo?.resetLabels(labelCnt: realm.objects(LabelRealmModel.self).count)
                    try! realm.write {
                        realm.deleteAll()
                    }
                }))
            }
            .padding(.top, -35)
            .navigationTitle("")
            .background(Color.DEPTH_5)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("navigation_back_btn")
                    })
                        .padding(.leading, -12)
                }
            )
        }
    }
}

struct ComposeMailData {
    let subject: String
    let receivers: [String]?
    let message: String
    let attachments: [AttachmentData]?
}

struct AttachmentData {
    let data: Data
    let mimeType: String
    let fileName: String
}

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var data: ComposeMailData
    let callback: MailViewCallback

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var data: ComposeMailData
        let callback: MailViewCallback

        init(presentation: Binding<PresentationMode>,
             data: Binding<ComposeMailData>,
             callback: MailViewCallback)
        {
            _presentation = presentation
            _data = data
            self.callback = callback
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?)
        {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $data, callback: callback)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(data.subject)
        vc.setToRecipients(data.receivers)
        vc.setMessageBody(data.message, isHTML: false)
        data.attachments?.forEach {
            vc.addAttachmentData($0.data, mimeType: $0.mimeType, fileName: $0.fileName)
        }

        vc.accessibilityElementDidLoseFocus()
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {}

    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}
