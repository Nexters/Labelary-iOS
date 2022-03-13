//
//  AppView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import Combine
import Foundation
import SwiftUI

struct AppView: View {
    @ObservedObject var output = Output()

    init() {
        UITabBar.appearance().barTintColor = UIColor(Color(hex: "#1B1D21"))
    }

    var body: some View {
        if Storage.isFirstTime() {
            VStack {
                OnboardingView(onFinished: {
                    output.endSplash()
                })
            }
        } else {
            NavigationView {
                TabView(selection: $output.selection, content: {
                    MainLabelingView()
                        .tabItem {
                            Image(output.selection == 0 ? "ico_labeling_on" : "ico_labeling_off")
                                .padding(.horizontal, -4)

                        }.tag(0)

                    SearchView()
                        .tabItem {
                            Image(output.selection == 1 ? "ico_home_on" : "ico_home_off")
                                .padding(.horizontal, -4)
                        }.tag(1)

                    LabelView()
                        .tabItem {
                            Image(output.selection == 2 ? "ico_album_on" : "ico_album_off")
                                .padding(.horizontal, -4)
                        }.tag(2)

                })
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
                        onSplash = false
                    }
                ).store(in: cancelbag)
        }
    }
}

