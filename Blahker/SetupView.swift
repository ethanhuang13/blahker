//
//  SetupView.swift
//  Blahker
//
//  Created by Ethanhuang on 2020/8/11.
//  Copyright © 2020 Elaborapp Co., Ltd. All rights reserved.
//

import SafariServices
import SwiftUI

struct SetupView: View {
    struct AlertIdentifier: Identifiable {
        enum Choice {
            case pleaseSetup
            case loaded
            case loadingFailed
        }

        var id: Choice
    }
    
    @State private var isLoadingBlockerList: Bool = false
    @State private var isLoadedFailedBefore: Bool = false
    @State private var alertIdentifier: AlertIdentifier?
    
    private var setupText = """
            Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

            App 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。

            欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。
            """
    
    private let willEnterForegroundPublisher = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    private let didEnterBackgroundPublisher = NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
    
    @ViewBuilder
    var loadingOverlay: some View {
        if isLoadingBlockerList {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(setupText)
                    .padding()
                Spacer()
                Button(action: {}, label: {
                    Text("拜託別按我")
                        .font(.title)
                })
                .padding()
            }
            .navigationTitle(Text("Blahker"))
            .toolbar(items: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { self.reload(manually: true) }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                    .disabled(isLoadingBlockerList)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "info")
                    })
                }
            })
            .overlay(loadingOverlay)
        }
        .onReceive(willEnterForegroundPublisher, perform: { _ in
            checkContentBlockerState(manually: false)
        })
        .onReceive(didEnterBackgroundPublisher, perform: { _ in
            scheduleContentBlockerReload()
        })
        .alert(item: $alertIdentifier, content: { alert in
            switch alert.id {
            case .pleaseSetup:
                return Alert(title: Text("請開啟內容阻擋器"),
                             message: Text("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker"),
                             dismissButton: .default(Text("已啟用，請重新檢查"), action: {
                                self.checkContentBlockerState(manually: true)
                             }))
            case .loaded:
                return Alert(title: Text("更新成功"),
                             message: Text("已下載最新擋廣告網站清單"),
                             dismissButton: .default(Text("確定")))
            case .loadingFailed:
                return Alert(title: Text("更新失敗"),
                      message: Text("請檢查網路設定"),
                      dismissButton: .default(Text("確定")))
            }
        })
        .onAppear(perform: { checkContentBlockerState(manually: false) })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func checkContentBlockerState(manually: Bool) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (state, error) -> Void in
            DispatchQueue.main.async {
                switch state?.isEnabled {
                case .some(true):
                    reload(manually: manually)
                    
                default:
                    self.isLoadingBlockerList = false
                    self.isLoadedFailedBefore = true
                    self.alertIdentifier = AlertIdentifier(id: .pleaseSetup)
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
        })
    }
    
    private func reload(manually: Bool) {
        isLoadingBlockerList = true
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { error -> Void in
            DispatchQueue.main.async {
                self.isLoadingBlockerList = false
                
                if manually || self.isLoadedFailedBefore {
                    if error == nil {
                        alertIdentifier = AlertIdentifier(id: .loaded)
                    } else {
                        alertIdentifier = AlertIdentifier(id: .loadingFailed)
                    }
                    
                    let feedbackType: UINotificationFeedbackGenerator.FeedbackType = (error == nil) ? .success : .error
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(feedbackType)
                }
                
                if error == nil {
                    print("reloadContentBlocker complete")
                    self.isLoadedFailedBefore = false
                } else {
                    print("reloadContentBlocker: \(String(describing: error))")
                    self.isLoadedFailedBefore = true
                }
            }
        })
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
