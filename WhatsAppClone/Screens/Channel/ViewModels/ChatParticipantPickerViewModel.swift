//
//  ChatParticipantPickerViewModel.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import Foundation

enum ChannelCreationRoute {
    case groupParticipantPicker
    case setUpGroupChat
}

enum ChannelConstants {
    static let maxGroupParticipants = 12
}

final class ChatParticipantPickerViewModel: ObservableObject {
    @Published var navStack = [ChannelCreationRoute]()
    @Published var selectedChatParticipants = [UserItem]()
    
    var showSelectedUsers: Bool {
        return !selectedChatParticipants.isEmpty
    }
    
    var disableNextButton: Bool {
        return selectedChatParticipants.isEmpty
    }
    
    // MARK: - Public Methods
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            guard let index = selectedChatParticipants.firstIndex(where: { $0.uid == item.uid }) else { return }
            selectedChatParticipants.remove(at: index)
        } else {
            selectedChatParticipants.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatParticipants.contains { $0.uid == user.uid }
        return isSelected
    }
}
