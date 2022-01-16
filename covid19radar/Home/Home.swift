//
//  Home.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct Home: View {
    @State var isRadarAnimating = false
    
    var body: some View {
        HomeNavigationCoordinator.make {
            ZStack {
                Color.init(white: 0.95).edgesIgnoringSafeArea(.all)
                GeometryReader { proxy in
                    ScrollView {
                        VStack(spacing: 32) {
                            HelthCheckBoard(value: $isRadarAnimating)
                                .onAppear {
                                    isRadarAnimating = true
                                }
                            ExposureCard()
                                .frame(width: max(0, proxy.size.width - 32))
                            PositiveRegistrationCard()
                                .frame(width: max(0, proxy.size.width - 32))
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("アプリを周りの人に知らせる")
                                }
                            }
                            .font(.system(size: 16))

                        }
                        .padding(16)
                    }
                    .navigationBarTitle("ホーム")
                }
            }
        }
        .environmentObject(HomeNavigationCoordinator())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
