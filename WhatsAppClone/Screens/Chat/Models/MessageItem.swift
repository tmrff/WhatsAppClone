//
//  MessageItem.swift
//  WhatsAppClone
//
//  Created by Thomas on 8/06/24.
//

import SwiftUI
import Firebase

struct MessageItem: Identifiable {
    let id: String
    let isGroupChat: Bool
    let text: String
    let type: MessageType
    let ownerUid: String
    let timeStamp: Date
    var sender: UserItem?
    
    var direction: MessageDirection {
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Holy Spagetti", type: .text, ownerUid: "1", timeStamp: Date())
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: false, text: "Hey", type: .text, ownerUid: "2", timeStamp: Date())
    
    var alignment: Alignment {
        return direction == . received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var showGroupParticipantInfo: Bool {
        return isGroupChat && direction == .received
    }
    
    var leadingPadding: CGFloat {
        return direction == .received ? 0 : horizontalPadding
    }
    
    var trailingPadding: CGFloat {
        return direction == .received ? horizontalPadding : 0
    }
    
    private let horizontalPadding: CGFloat = 25
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, isGroupChat: false, text: "Hi", type: .text, ownerUid: "3", timeStamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: true, text: "Check this photo out", type: .photo, ownerUid: "4", timeStamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Play this video", type: .video, ownerUid: "5", timeStamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: false, text: "", type: .audio, ownerUid: "6", timeStamp: Date())
    ]
}

extension MessageItem {
    init(id: String, isGroupChat: Bool, dict: [String: Any]) {
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
}
