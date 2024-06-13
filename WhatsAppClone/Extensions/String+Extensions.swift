//
//  String+Extensions.swift
//  WhatsAppClone
//
//  Created by Thomas on 13/06/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
