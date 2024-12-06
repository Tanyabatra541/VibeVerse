
import Foundation
import UIKit

struct SignupAllDetailsModel {
    let personalDetails: SignupPersonalDetailsModel
    let dob: String
    let interestsDetails: SignupInterestsDetailsModel
    let workDetails: SignupWorkDetailsModel
    let profileImage: UIImage
}
struct SignupPersonalDetailsModel {
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let password: String
}

struct SignupInterestsDetailsModel {
    let interests: String
    let goodAtThings: String
    let experience: String
}

struct SignupWorkDetailsModel {
    let workLink: String
    let description: String
    let achievements: String
}



//struct Interests {
//    let interest: String
//}
//struct GoodAtThings {
//    let goodAt: String
//}
