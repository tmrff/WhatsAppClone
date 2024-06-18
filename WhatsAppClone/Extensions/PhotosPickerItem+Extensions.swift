//
//  PhotosPickerItem+Extensions.swift
//  WhatsAppClone
//
//  Created by Thomas on 18/06/2024.
//

import Foundation
import PhotosUI
import SwiftUI
          
extension PhotosPickerItem {
    var isVideo: Bool {
        let videoUTTTypes: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTTypes.contains(where: supportedContentTypes.contains)
    }
}
