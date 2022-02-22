//  Credits to https://blckbirds.com/post/prevent-the-keyboard-from-hiding-swiftui-view/.
//  Referred to this for inspiration.
//
//  KeyboardResponder.swift
//  peggleclone
//
//  Created by Stuart Long on 30/1/22
//

import Foundation
import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var center: NotificationCenter

    init(center: NotificationCenter = .default) {
        self.center = center
        self.center.addObserver(self,
                                selector: #selector(keyBoardWillShow(notification:)),
                                name: UIResponder.keyboardWillShowNotification,
                                object: nil)
        self.center.addObserver(self,
                                selector: #selector(keyBoardWillHide(notification:)),
                                name: UIResponder.keyboardWillHideNotification,
                                object: nil)
    }

    @objc func keyBoardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                withAnimation {
                   currentHeight = keyboardSize.height
                }
            }
        }

    @objc func keyBoardWillHide(notification: Notification) {
            withAnimation {
               currentHeight = 0
            }
        }
}
