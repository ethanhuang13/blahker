//
//  AboutView.swift
//  Blahker
//
//  Created by ethanhuang on 2020/8/29.
//  Copyright © 2020 Elaborapp Co., Ltd. All rights reserved.
//

import MessageUI
import SwiftUI

struct AboutView: View {
    struct AlertIdentifier: Identifiable {
        enum Choice {
            case setupMail
        }

        var id: Choice
    }

    @State private var alertIdentifier: AlertIdentifier?
    @State private var isShowingReportMailView = false
    @State private var mailResult: Result<MFMailComposeResult, MFMailComposeError>? = nil
    @State private var isShowingAboutSafariView = false

    var body: some View {
        List {
            Section(content: {
                listCell
                reportCell
            })
            Section(content: {
                rateCell
                shareCell
                aboutCell
            })
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("關於", displayMode: .large)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isShowingReportMailView, content: {
            MailView(
                isShowing: $isShowingReportMailView,
                result: $mailResult,
                toRecipients: ["elaborapp+blahker@gmail.com"],
                subject: "[Blahker 使用者回報]我有問題",
                messageBody: "Hello 開發者，\n\n建議加入擋蓋版廣告之網站：\n（請附上螢幕截圖，以利判斷，謝謝）\n\n")
        })
        .sheet(isPresented: $isShowingAboutSafariView, content: {
            SafariView(url: URL(string: "https://github.com/ethanhuang13/blahker/blob/master/README.md")!)
        })
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .setupMail:
                return Alert(
                    title: Text("請先啟用 iOS 郵件"),
                    message: Text("請先至 iOS 郵件 app 登入信箱，或寄信到 elaborapp+blahker@gmail.com"),
                    dismissButton: .default(Text("確定")))
            }
        }
    }

    var listCell: some View {
        NavigationLink("已阻擋的蓋板廣告網站", destination: Text(""))
    }

    var reportCell: some View {
        Button(action: {
            if MailView.canSendMail {
                isShowingReportMailView = true
            } else {
                alertIdentifier = AlertIdentifier(id: .setupMail)
            }
        }, label: {
            VStack(alignment: .leading) {
                Text("回報廣告網站或問題")
                Text("請附上螢幕截圖，以利判斷")
                    .font(.caption)
            }
        })
        .foregroundColor(.primary)
    }

    var rateCell: some View {
        Button("為我們評分") {
            guard let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inapprate") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        .foregroundColor(.primary)
    }

    var shareCell: some View {
        Button("推薦給朋友") {
            let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inappshare")!
            let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(avc, animated: true, completion: nil)
        }
        .foregroundColor(.primary)
    }

    var aboutCell: some View {
        Button(action: {
            isShowingAboutSafariView = true
        }, label: {
            VStack(alignment: .leading) {
                Text("關於 Blahker 與常見問題")
                Text(versionString)
                    .font(.caption)
            }
        })
        .foregroundColor(.primary)
    }

    var versionString: String {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        let build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        return "v\(version)(\(build))"
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutView()
                .preferredColorScheme(.light)
            AboutView()
                .preferredColorScheme(.dark)
        }
    }
}
