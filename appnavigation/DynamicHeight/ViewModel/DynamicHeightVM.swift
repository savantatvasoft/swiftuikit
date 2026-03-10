//
//  DynamicHeightVM.swift
//  appnavigation
//
//  Created by MACM72 on 09/03/26.
//

import Foundation

enum DummyDescription: CaseIterable {

    case short
    case medium
    case long
    case extraLong

    var value: String {
        switch self {

        case .short:
            return "This is a short description used to test dynamic label height."

        case .medium:
            return "This is a medium length description used in testing dynamic layouts. The goal is to see how the UI behaves when text becomes slightly longer than a single line."

        case .long:
            return "This is a longer description used for testing UI components where dynamic text size matters. When the content grows, the container view should expand accordingly until it reaches its maximum limit."

        case .extraLong:
            return "This is an extra long description intended to simulate a real scenario where the text content can grow significantly. In many applications such as article previews, user generated content, or chat messages, the UI must adapt to text that may span multiple lines. The container should expand dynamically but must respect the maximum height constraint."
        }
    }
}

//Create Observable Model
class DescriptionModel: NSObject {
    @objc dynamic var text: String = ""
}
