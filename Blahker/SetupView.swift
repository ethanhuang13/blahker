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
    enum AlertID: String, Identifiable {
        case pleaseSetup
        case reloaded
        case reloadFailed
        case purchased
        case purchaseFailed
        case purchaseFailedCantMakePayments
        
        var id: String { rawValue }
    }
    
    @State private var isLoadingBlockerList: Bool = false
    @State private var isLoadedFailedBefore: Bool = false
    @State private var alertId: AlertID?
    @State private var isDonateActionSheetPresented: Bool = false
    @State private var showAbout = false

    #if targetEnvironment(macCatalyst)
    private var setupText = """
Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

請確定「Safari」 > 「偏好設定」 > 「延伸功能」，已經啟用 Blahker，便可關閉此 app。

未來若要移除 Blahker，請直接刪除此 app 即可。
"""
    #else
    private var setupText = """
Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

App 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。

欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。
"""
    #endif
    
    private let willEnterForegroundPublisher = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    private let didEnterBackgroundPublisher = NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if isLoadingBlockerList {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    private var donateActionSheet: ActionSheet {
        let purchaseCompletion: PurchaseCompletion = { result in
            switch result {
            case .success:
                alertId = .purchased
            case .failure(let reason):
                switch reason {
                case .userCancelled:
                    break
                case .failure(underlyingError: let error):
                    print("交易失敗：\(error.localizedDescription)")
                    alertId = .purchaseFailed
                case .cantMakePayments:
                    alertId = .purchaseFailedCantMakePayments
                }
            }
        }
        
        return ActionSheet(title: Text("支持開發者"),
                           message: Text("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～"),
                           buttons: [
                            .default(Text("打賞小小費"), action: {
                                PurchaseManager.shared.startPurchase(productType: .tips1, completion: purchaseCompletion)
                            }),
                            .default(Text("打賞小費"), action: {
                                PurchaseManager.shared.startPurchase(productType: .tips2, completion: purchaseCompletion)
                            }),
                            .default(Text("破費"), action: {
                                PurchaseManager.shared.startPurchase(productType: .tips3, completion: purchaseCompletion)
                            }),
                            .default(Text("我不出錢，給個五星評分總行了吧"), action: {
                                guard let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inappnotdonate") else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }),
                            .cancel(Text("算了吧，不值得"))
                           ])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(setupText)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    isDonateActionSheetPresented = true
                }, label: {
                    Text("拜託別按我")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.primary)
                        .background(Color.secondary
                                        .clipShape(Capsule(style: .continuous))
                                        .padding(-14)
                                        .opacity(0.4))
                })
                .padding(.bottom, 80)
                .actionSheet(isPresented: $isDonateActionSheetPresented) {
                    donateActionSheet
                }
            }
            .background(NavigationLink(
                            destination: AboutView(),
                            isActive: $showAbout,
                            label: {
                                EmptyView()
                            }))
            .navigationBarTitle(Text("Blahker"), displayMode: .large)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { reload(manually: true) }, label: {
                        Text("重新整理")
                            .font(Font.body.weight(.bold))
                    })
                    .foregroundColor(.primary)
                    .disabled(isLoadingBlockerList)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAbout = true
                    }, label: {
                        Text("關於")
                            .font(Font.body.weight(.bold))
                    })
                    .foregroundColor(.primary)
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
        .alert(item: $alertId, content: { alert in
            switch alert {
            case .pleaseSetup:
                return Alert(title: Text("請開啟內容阻擋器"),
                             message: Text("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker"),
                             dismissButton: .default(Text("已啟用，請重新檢查"), action: {
                                checkContentBlockerState(manually: true)
                             }))
            case .reloaded:
                return Alert(title: Text("更新成功"),
                             message: Text("已下載最新擋廣告網站清單"),
                             dismissButton: .cancel(Text("確定")))
            case .reloadFailed:
                return Alert(title: Text("更新失敗"),
                             message: Text("請檢查網路設定"),
                             dismissButton: .cancel(Text("確定")))
            case .purchased:
                return Alert(title: Text("打賞成功！"),
                             message: Text("感激不盡，Blahker 有你的支持將會越來越好"),
                             dismissButton: .cancel(Text("不客氣")))
            case .purchaseFailed:
                return Alert(title: Text("唉呀"),
                             message: Text("謝謝你，但是交易失敗了。請稍候再試"),
                             dismissButton: .cancel(Text("好吧")))
            case .purchaseFailedCantMakePayments:
                return Alert(title: Text("唉呀"),
                             message: Text("謝謝你，但是你沒有辦法付費耶。請檢查 iTunes 帳號的付費權限喔"),
                             dismissButton: .cancel(Text("好吧")))
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
                    isLoadingBlockerList = false
                    isLoadedFailedBefore = true
                    alertId = .pleaseSetup
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
        })
    }
    
    private func reload(manually: Bool) {
        isLoadingBlockerList = true
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier) { error in
            DispatchQueue.main.async {
                isLoadingBlockerList = false
                
                if manually || isLoadedFailedBefore {
                    if error == nil {
                        alertId = .reloaded
                    } else {
                        alertId = .reloadFailed
                    }
                    
                    let feedbackType: UINotificationFeedbackGenerator.FeedbackType = (error == nil) ? .success : .error
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(feedbackType)
                }
                
                if error == nil {
                    print("reloadContentBlocker complete")
                    isLoadedFailedBefore = false
                } else {
                    print("reloadContentBlocker: \(String(describing: error))")
                    isLoadedFailedBefore = true
                }
            }
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SetupView()
                .preferredColorScheme(.dark)
            SetupView()
                .preferredColorScheme(.light)
        }
    }
}
