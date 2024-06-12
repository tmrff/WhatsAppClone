//
//  ChatParticipantPickerViewModel.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import Foundation
import Firebase

enum ChannelCreationRoute {
    case groupParticipantPicker
    case setUpGroupChat
}

enum ChannelConstants {
    static let maxGroupParticipants = 12
}

@MainActor
final class ChatParticipantPickerViewModel: ObservableObject {
    @Published var navStack = [ChannelCreationRoute]()
    @Published var selectedChatParticipants = [UserItem]()
    @Published private(set) var users = [UserItem]()
    
    private var lastCursor: String?
    
    var showSelectedUsers: Bool {
        return !selectedChatParticipants.isEmpty
    }
    
    var disableNextButton: Bool {
        return selectedChatParticipants.isEmpty
    }
    
    var isPaginatable: Bool {
        return !users.isEmpty
    }
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    // MARK: - Public Methods
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid }
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
            print("lastCursor: \(lastCursor) \(users.count)")
        } catch {
            print("💿 Failed to fetch users in ChatParticipantPickerViewModel")
        }
    }
    
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
