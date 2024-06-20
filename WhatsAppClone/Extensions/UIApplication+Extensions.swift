//
//  UIApplication+Extensions.swift
//  WhatsAppClone
//
//  Created by Thomas on 20/06/2024.
//

import Foundation
import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        UIApplication
            .shared
            .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
