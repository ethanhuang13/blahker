//
//  AboutViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/12/3.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class AboutViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.selectedBackgroundView = selectedBackgroundView

        switch cell.reuseIdentifier {
        case .some("about"):
            cell.detailTextLabel?.text = {
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
                return "v\(version)(\(build))"
            }()
            
        default: break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath),
            let identifier = cell.reuseIdentifier {

            switch identifier {
            case "list":
                let storyboard = UIStoryboard(name: "BlockerList", bundle: nil)
                if let vc = storyboard.instantiateInitialViewController() as? BlockerListViewController {
                    navigationController?.show(vc, sender: self)
                }

            case "report":
                self.report()

            case "rate":
                guard let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inapprate") else { return }
                UIApplication.shared.openURL(url)

            case "share":
                guard let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inappshare") else { return }
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                let popPC = vc.popoverPresentationController
                popPC?.sourceView = cell
                popPC?.sourceRect = cell.bounds

                self.present(vc, animated: true, completion: nil)

            case "about":
                guard let url = URL(string: "https://github.com/ethanhuang13/blahker/blob/master/README.md") else { return }
                let vc = SFSafariViewController(url: url)
                vc.title = "關於"

                if #available(iOS 10.0, *) {
                    vc.preferredBarTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    vc.preferredControlTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }

                self.present(vc, animated: true, completion: { })
                
            default:
                break
            }
        }
    }

    func report() {
        guard MFMailComposeViewController.canSendMail() else {
            let alertController = UIAlertController(title: "請先啟用 iOS 郵件", message: "請先至 iOS 郵件 app 登入信箱，或寄信到 elaborapp+blahker@gmail.com", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["elaborapp+blahker@gmail.com"])
        vc.setSubject("[Blahker 使用者回報]我有問題")
        vc.setMessageBody("Hello 開發者，\n\n建議加入擋蓋版廣告之網站：\n（請附上螢幕截圖，以利判斷，謝謝）\n\n", isHTML: false)
        vc.mailComposeDelegate = self
        self.present(vc, animated: true, completion: { })
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { }
    }
}
