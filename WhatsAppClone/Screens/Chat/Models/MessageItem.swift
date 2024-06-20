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
    let thumbnailURL: String?
    var thumbnailHeight: CGFloat?
    var thumbnailWidth: CGFloat?
    
    var direction: MessageDirection {
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Holy Spagetti", type: .text, ownerUid: "1", timeStamp: Date(), thumbnailURL: nil)
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: false, text: "Hey", type: .text, ownerUid: "2", timeStamp: Date(), thumbnailURL: nil)
    
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
    
    var imageSize: CGSize {
        let photoWidth = thumbnailWidth ?? 0
        let photoHeight = thumbnailHeight ?? 0
        let imageHeight = CGFloat(photoHeight / photoWidth * imageWidth)
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageWidth: CGFloat {
        let photoWidth = (UIWindowScene.current?.screenWidth ?? 0) / 1.5
        return photoWidth
    }
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, isGroupChat: false, text: "Hi", type: .text, ownerUid: "3", timeStamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: true, text: "Check this photo out", type: .photo, ownerUid: "4", timeStamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Play this video", type: .video, ownerUid: "5", timeStamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "", type: .audio, ownerUid: "6", timeStamp: Date(), thumbnailURL: nil)
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
        self.thumbnailURL = dict[.thumbnailUrl] as? String ?? nil
        self.thumbnailWidth = dict[.thumbnailWidth] as? CGFloat ?? 0
        self.thumbnailHeight = dict[.thumbnailHeight] as? CGFloat ?? 0
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
}
