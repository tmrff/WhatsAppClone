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

enum ChannelCreationError: Error {
    case noChatParticipant
    case failedToCreateUniqueIds
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
    
    private var isDirectChannel: Bool {
        return selectedChatParticipants.count == 1
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
    
    //    func buildDirectChannel() async -> Result<ChannelItem, Error> {
    //
    //    }
    
    func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatParticipants.isEmpty else { return .failure(ChannelCreationError.noChatParticipant) }
        
        guard let channelId = FirebaseConstants.ChannelsRef.childByAutoId().key,
              let currentUid = Auth.auth().currentUser?.uid
                //              let messageId = FirebaseConstants.MessagesRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueIds) }
        
        let timeStamp = Date().timeIntervalSince1970
        var membersUids = selectedChatParticipants.compactMap { $0.uid }
        membersUids.append(currentUid)
        
        var channelDict: [String: Any] = [
            .id : channelId,
            .lastMessage: "",
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .membersUids: membersUids,
            .membersCount: membersUids.count,
            .adminUids: [currentUid]
        ]
        
        if let channelName = channelName, channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        
        FirebaseConstants.ChannelsRef.child(channelId).setValue(channelDict)
        
        membersUids.forEach { userId in
            // keeping an index of the channel that a specific user belongs to
            FirebaseConstants.UserChannelsRef.child(userId).child(channelId).setValue(true)
        }
        
        // make sure that a direct channel is unique
        if isDirectChannel {
            let chatParticipant = selectedChatParticipants[0]
            FirebaseConstants.UserDirectChannels.child(currentUid).child(chatParticipant.uid).setValue([channelId: true])
            FirebaseConstants.UserDirectChannels.child(chatParticipant.uid).child(currentUid).setValue([channelId: true])
        }
            
        var newChannelItem = ChannelItem(channelDict)
        newChannelItem.members = selectedChatParticipants
        return .success(newChannelItem)
    }
}
