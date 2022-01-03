//
//  WebView.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  @Binding var url: URL
   
  func makeUIView(context: Context) -> WKWebView {
    WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.load(URLRequest(url: url))
  }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: .constant(URL(string: "https://example.com")!))
    }
}
