//
//  Constants.swift
//  ChatApp
//
//  Created by Anna Belousova on 24.03.2022.
//

import Firebase

struct TextConstants {
    static let fullnameFilename = "FullName.txt"
    static let descriptionFileName = "Description.txt"
    static let textViewPlaceholder = "Enter message..."
}

struct URLConstants {
    static let referenceToChannels = Firestore.firestore().collection("channels")
}

struct Tokens {
    static let pixabay = "27005211-a0d699758faad00b881360df1"
}
