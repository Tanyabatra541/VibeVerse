
import Foundation
import UIKit
import FirebaseFirestoreInternal

struct MessageModel {
    let senderId: String
    let receiverId: String
    let text: String
    let timestamp: Date
    
    init?(dictionary: [String: Any]) {
        guard let senderId = dictionary["senderId"] as? String,
              let receiverId = dictionary["receiverId"] as? String,
              let text = dictionary["text"] as? String,
              let timestamp = dictionary["timestamp"] as? Timestamp else {
            return nil
        }
        self.senderId = senderId
        self.receiverId = receiverId
        self.text = text
        self.timestamp = timestamp.dateValue()
    }
}
