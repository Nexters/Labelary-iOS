//
//  SettingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/12.
//

import MessageUI
import SwiftUI
import UIKit

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = ViewModel()
    @State private var showMailView = false
    @State private var showAlert = false
    @State private var mailData = ComposeMailData(subject: "Report", receivers: ["mjwoo001@gmail.com"], message: " write message...", attachments: [AttachmentData(data: "text".data(using: .utf8)!, mimeType: "text/plain", fileName: "text.txt")])

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.top)
            Color.DEPTH_5.edgesIgnoringSafeArea(.bottom)
            VStack {
                Button(action: {
                    let url = URL(string: "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                }, label: {
                    Text("앱스토어에 리뷰쓰기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {
                    guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
                    let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                }, label: {
                    Text("친구에게 추천하기")
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
                    Text("이용방법 보기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {}, label: {
                    Text("빠른 라벨링 설정하기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.top, -9)
                Button(action: {
                    showMailView.toggle()
                }, label: {
                    Text("피드백 보내기")
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
                }, label: {
                    VStack(alignment: .leading) {
                        Text("라벨 초기화하기")
                            .foregroundColor(Color.LABEL_RED_ACTIVE)
                            .font(Font.B1_MEDIUM)
                            .padding(.bottom, 0.5)
                        Text("라벨 내역이 초기화되며, 스크린샷은 삭제되지 않습니다.")
                            .foregroundColor(Color.PRIMARY_2)
                            .font(Font.B2_REGULAR)
                    }.padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 10)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                Spacer()
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

    class ViewModel: ObservableObject {
        // let removeAllLabel
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
