//
//  OverlayLoading.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI
import SwiftUI
import SwiftUIReplicator

struct OverlayLoading: View {
    var isHidden: Bool = false
    
    var body: some View {
        if !isHidden {
            ZStack {
                Rectangle().fill(.white).opacity(0.5)
                ActivityIndicator(style: .rectangleScale)
                    .accentColor(.gray)
            }
        } else {
            EmptyView()
        }
    }
}

struct OverlayLoading_Previews: PreviewProvider {
    static var previews: some View {
        OverlayLoading()
    }
}
