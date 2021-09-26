//
//  AppView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import Combine
import SwiftUI

struct AppView: View {
    @ObservedObject var output = Output()

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.DEPTH_4_BG)
        UITabBar.appearance().barTintColor = UIColor(Color.DEPTH_4_BG)
    }

    var body: some View {
        if output.onSplash {
            VStack {
                Text("스크린샷\n정리가 어렵다면")
                    .foregroundColor(Color.PRIMARY_1)
            }.onAppear {
                output.endSplash()
            }
        } else {
            if !output.isFinishOnboarding {
                OnboardingView(onFinished: {
                    output.isFinishOnboarding = true
                })
            } else {
                NavigationView {
                    TabView(selection: $output.selection, content: {
                        MainLabelingView()
                            .tabItem {
                                Image(output.selection == 0 ? "ico_labeling_on" : "ico_labeling_off")
                            }.tag(0)
                        SearchView()
                            .tabItem {
                                Image(output.selection == 1 ? "ico_home_on" : "ico_home_off")
                            }.tag(1)
                        LabelView() 
                            .tabItem {
                                Image(output.selection == 2 ? "ico_album_on" : "ico_album_off")
                            }.tag(2)
                    })
                }
            }
        }
    }

    class Output: ObservableObject {
        @Published var selection = 0
        @Published var onSplash = true
        @Published var isFinishOnboarding = false

        let cancelbag = CancelBag()

        func endSplash() {
            Just(false)
                .delay(for: .seconds(2), scheduler: RunLoop.main, options: .none)
                .asDriver()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [self] _ in
                        print("ddddd")
                        onSplash = false
                    }
                ).store(in: cancelbag)
        }
    }
}
