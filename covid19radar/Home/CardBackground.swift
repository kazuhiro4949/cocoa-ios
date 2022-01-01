//
//  CardBackground.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct CardBackground: View {
    var color: Color = .white
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color)
            .shadow(color: Color(white: 0.5, opacity: 0.2), radius: 10, x: 0, y: 5)
    }
}

struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        CardBackground()
    }
}
