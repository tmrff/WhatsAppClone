//
//  FirebaseConstants.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import Foundation
import Firebase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
}
