//
//  MessageItem.swift
//  WhatsAppClone
//
//  Created by Thomas on 8/06/24.
//

import SwiftUI

struct MessageItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    let type: MessageType
    let direction: MessageDirection
    
    static let sentPlaceholder = MessageItem(text: "Holy Spagetti", type: .text, direction: .sent)
    static let receivedPlaceholder = MessageItem(text: "Hey", type: .text, direction: .received)
    
    var alignment: Alignment {
        return direction == . received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let stubMessages: [MessageItem] = [
        .init(text: "Hi", type: .text, direction: .sent),
        .init(text: "Check this photo out", type: .photo, direction: .received),
        .init(text: "Play this video", type: .video, direction: .sent)
    ]
}

enum MessageType {
    case text, photo, video
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
