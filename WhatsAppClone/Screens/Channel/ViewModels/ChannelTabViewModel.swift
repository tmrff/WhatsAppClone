//
//  ChannelTabViewModel.swift
//  WhatsAppClone
//
//  Created by Thomas on 12/06/24.
//

import Foundation

final class ChannelTabViewModel: ObservableObject {
    
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatParticipantPickerView = false
    
    func onNewChannelCreation(_ channel: ChannelItem) {
        showChatParticipantPickerView = false
        newChannel = channel
        navigateToChatRoom = true
    }
}
