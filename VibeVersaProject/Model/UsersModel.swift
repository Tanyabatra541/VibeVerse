import Foundation
import UIKit

struct UsersModel {
    let id: String  // Unique identifier for the user
    let firstName: String
    let lastName: String
    let phone: String?
    let email: String?
    let workLink: String?
    let description: String?
    let achievements: String?
    let profileImageUrl: String? // URL for the profile image
    var profileImage: UIImage? // Holds the downloaded profile image (optional)
    var joinedCommunities: [String] // List of joined communities
    let goodAtThings: [String] // Skills user is good at (parsed into an array)
    let interests: [String] // Skills user needs help with (parsed into an array)

    init?(dictionary: [String: Any]) {
        // Ensure the ID is present
        guard let id = dictionary["userId"] as? String,
              let personalDetails = dictionary["personalDetails"] as? [String: Any],
              let firstName = personalDetails["firstName"] as? String,
              let lastName = personalDetails["lastName"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = personalDetails["phone"] as? String
        self.email = personalDetails["email"] as? String
        
        if let workDetails = dictionary["workDetails"] as? [String: Any] {
            self.workLink = workDetails["workLink"] as? String
            self.description = workDetails["description"] as? String
            self.achievements = workDetails["achievements"] as? String
        } else {
            self.workLink = nil
            self.description = nil
            self.achievements = nil
        }
        
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.profileImage = nil // Default to nil; fetched asynchronously
        self.joinedCommunities = dictionary["joinedCommunities"] as? [String] ?? []
        
        // Parse `goodAtThings` into an array
        if let interestsDetails = dictionary["interestsDetails"] as? [String: Any],
           let goodAtThingsString = interestsDetails["goodAtThings"] as? String {
            self.goodAtThings = goodAtThingsString
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        } else {
            self.goodAtThings = []
        }
        
        // Parse `interests` into an array
        if let interestsDetails = dictionary["interestsDetails"] as? [String: Any],
           let interestsString = interestsDetails["interests"] as? String {
            self.interests = interestsString
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        } else {
            self.interests = []
        }
    }
    
    func fetchProfileImage(completion: @escaping (UIImage?) -> Void) {
        guard let urlString = profileImageUrl, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
