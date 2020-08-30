//
//  MailView.swift
//  Blahker
//
//  Created by ethanhuang on 2020/8/29.
//  Copyright © 2020 Elaborapp Co., Ltd. All rights reserved.
//

import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, MFMailComposeError>?
    var toRecipients: [String]
    var subject: String
    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, MFMailComposeError>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, MFMailComposeError>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            if let error = error as? MFMailComposeError {
                self.result = .failure(error)
            } else {
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing, result: $result)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(toRecipients)
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
