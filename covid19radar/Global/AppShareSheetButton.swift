//
//  AppShareSheetButton.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/08.
//

import SwiftUI

struct AppShareSheetButton: View {
    @State private var isPresented = false
    
    var body: some View {
        DefaultButton(systemImageName: "square.and.arrow.up", title: "アプリを共有する") {
            isPresented = true
        }.sheet(
            isPresented: $isPresented) {
                
            } content: {
                ShareSheet(
                    text: "接触確認アプリCOCOA",
                    url: "https://itunes.apple.com/jp/app/id1516764458?mt=8"
                )
            }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var text: String?
    var url: String?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [ShareItem(url)], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

struct AppShareSheetButton_Previews: PreviewProvider {
    static var previews: some View {
        AppShareSheetButton()
    }
}

class ShareItem<T>: NSObject, UIActivityItemSource {
    
    private let item: T
    
    init(_ item: T) {
        self.item = item
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return item
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return activityViewControllerPlaceholderItem(activityViewController)
    }
}
